//
//  MyCoinViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit
import Combine

class MyCoinViewController: UIViewController {
    
    private var coinViewModel = CoinViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let refreshCoinDataController = UIRefreshControl()
    
    // Bookmark List
    var bookmarkList: [String] = []
    
    // tableView
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CoinBookmarkTVCell.self, forCellReuseIdentifier: "coinBookmarkListCell")
        return tableView
    }()
    
    // indicatorView
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // Error Label
    private let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 18)
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        return errorLabel
    }()
    
    // Status Label
    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        statusLabel.textColor = .gray
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.isHidden = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        return statusLabel
    }()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindData()
        setupRefreshData()
        
        UserViewModel.shared.fetchUserInfo()
    }
        
    // UI Update
    func setupUI() {
        self.title = "Coin Bookmark List"
        self.view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(errorLabel)
        self.view.addSubview(statusLabel)
        
        let safeArea = self.view.safeAreaLayoutGuide
        setupLayout(safeArea)
    }
    
    // setup NSLayout
    func setupLayout(_ safeArea: UILayoutGuide) {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            errorLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // setup BindData
    private func setupBindData() {
        coinViewModel.$bookmarkedCoinData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedCoinData in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.tableView.isHidden = bookmarkedCoinData.isEmpty
                self.statusLabel.isHidden = !bookmarkedCoinData.isEmpty
                self.statusLabel.text = bookmarkedCoinData.isEmpty ? "리스트가 존재하지 않습니다" : ""
                self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        coinViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.isHidden = true
                    self?.statusLabel.isHidden = true
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        coinViewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.errorLabel.text = errorMessage
                self?.errorLabel.isHidden = (errorMessage == nil)
            }
            .store(in: &cancellables)
        
        UserViewModel.shared.$userInfo
            .sink { [weak self] userInfo in
                guard let self = self else { return }
                if let userInfo = userInfo {
                    Task {
                        do {
                            let bookmarks = try await self.coinViewModel.fetchCheckBookmark(userId: userInfo.id ?? "", userNickname: userInfo.nickName ?? "")
                            DispatchQueue.main.async {
                                self.bookmarkList = bookmarks
                                self.coinViewModel.filterBookmarkedCoinData()
                                self.statusLabel.isHidden = !self.bookmarkList.isEmpty
                                self.statusLabel.text = self.bookmarkList.isEmpty ? "리스트가 존재하지 않습니다" : ""
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("북마크 에러 발생: \(error.localizedDescription)")
                        }
                    }
                } else {
                    self.bookmarkList = []
                    self.coinViewModel.filterBookmarkedCoinData()
                    self.tableView.reloadData()
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = "로그인 후 사용해주세요."
                }
            }
            .store(in: &cancellables)
    }
        
    // refresh Data
    func setupRefreshData() {
        refreshCoinDataController.addTarget(self, action: #selector(refreshTableData(refresh:)), for: .valueChanged)
        refreshCoinDataController.attributedTitle = NSAttributedString(string: "Update Data")
        tableView.refreshControl = refreshCoinDataController
    }
    @objc func refreshTableData(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.coinViewModel.updateCoinData()
            refresh.endRefreshing()
        }
    }
}

// TableViewDataSource, TableViewDelegate 분리
extension MyCoinViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinViewModel.bookmarkedCoinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinBookmarkListCell", for: indexPath) as? CoinBookmarkTVCell else {
            return UITableViewCell()
        }
        
        let coinCell = coinViewModel.bookmarkedCoinData[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(item: coinCell, checkBookmark: coinViewModel.bookmarkList)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoinCell = coinViewModel.bookmarkedCoinData[indexPath.row]
        let isBookmarkSelected = true
        
        let coinDetailViewController = CoinDetailViewController(coindata: selectedCoinCell, isBookmarkSelected: isBookmarkSelected)
        coinDetailViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = coinDetailViewController.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return context.maximumDetentValue * 0.75
                }),
            ]
            sheet.prefersGrabberVisible = true
        }
        
        present(coinDetailViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
