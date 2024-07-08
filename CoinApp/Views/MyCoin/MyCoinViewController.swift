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
        setupBarButtonItem()
        UserViewModel.shared.fetchUserInfo()
        
        checkLoginStatus()
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
            
            statusLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
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
                self.updateStatusLabel()
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
                }
            }
            .store(in: &cancellables)
        
        coinViewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.errorLabel.text = errorMessage
                self?.errorLabel.isHidden = (errorMessage == nil)
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    self?.statusLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        UserViewModel.shared.$userInfo
            .sink { [weak self] userInfo in
                guard let self = self else { return }
                if let userInfo = userInfo, userInfo.isLogin == true {
                    Task {
                        do {
                            _ = try await self.coinViewModel.fetchCheckBookmark(userId: userInfo.id ?? "", userNickname: userInfo.nickName ?? "")
                            self.coinViewModel.filterBookmarkedCoinData()
                            DispatchQueue.main.async {
                                self.updateStatusLabel()
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("북마크 에러 발생: \(error.localizedDescription)")
                        }
                    }
                } else {
                    self.coinViewModel.bookmarkedCoinData.removeAll()
                    self.tableView.reloadData()
                    self.updateStatusLabel()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateStatusLabel() {
        if let userInfo = UserViewModel.shared.userInfo, userInfo.isLogin == true {
            if coinViewModel.bookmarkedCoinData.isEmpty {
                statusLabel.text = "리스트가 존재하지 않습니다"
                statusLabel.isHidden = false
            } else {
                statusLabel.isHidden = true
            }
        } else {
            statusLabel.text = "로그인 후 사용해주세요."
            statusLabel.isHidden = false
        }
    }
    
    private func checkLoginStatus() {
        if UserViewModel.shared.userInfo == nil || UserViewModel.shared.userInfo?.isLogin == false {
            statusLabel.text = "로그인 후 사용해주세요."
            statusLabel.isHidden = false
        }
    }
    
    // setup UIBarButton - 삭제버튼
    func setupBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(handlerDelete))
        
    }
    @objc func handlerDelete() {
        let shouldBeEdited = !tableView.isEditing
        tableView.setEditing(shouldBeEdited, animated: true)
    }
    
    
    // refresh Data
    func setupRefreshData() {
        refreshCoinDataController.addTarget(self, action: #selector(refreshTableData(refresh:)), for: .valueChanged)
        refreshCoinDataController.attributedTitle = NSAttributedString(string: "데이터 새로고침")
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
