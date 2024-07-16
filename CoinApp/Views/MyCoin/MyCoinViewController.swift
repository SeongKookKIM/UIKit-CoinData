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
        setupBarButtonItem()
        UserViewModel.shared.fetchUserInfo()
    }
    
    // UI Update
    private func setupUI() {
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
    private func setupLayout(_ safeArea: UILayoutGuide) {
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
                            self.updateStatusLabel()
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
    
    // 데이터 패칭, 로그인 유무, 리스트 존재 텍스트 분기처리
    private func updateStatusLabel() {
        if let errorText = errorLabel.text, !errorText.isEmpty {
            statusLabel.isHidden = true
            return
        }
        
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
    
    // setup UIBarButton - 삭제버튼
    private func setupBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(handlerDelete))
    }
    
    @objc func handlerDelete() {
        let shouldBeEdited = !tableView.isEditing
        tableView.setEditing(shouldBeEdited, animated: true)
    }
}

// TableViewDataSource, TableViewDelegate 분리
extension MyCoinViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TableView Cell갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinViewModel.bookmarkedCoinData.count
    }
    
    // TableView Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinBookmarkListCell", for: indexPath) as? CoinBookmarkTVCell else {
            return UITableViewCell()
        }
        
        let coinCell = coinViewModel.bookmarkedCoinData[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(item: coinCell, checkBookmark: coinViewModel.bookmarkList)
        
        return cell
    }
    
    // TableView Cell Click
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
    
    // TableView Cell Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let coinName = coinViewModel.bookmarkedCoinData[indexPath.row]
        
        if let userInfo = UserViewModel.shared.userInfo {
            
            self.coinViewModel.bookmarkedCoinData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            Task {
                do {
                    try await self.coinViewModel.deleteBookmarkedCoinData(userId: userInfo.id ?? "", userNickname: userInfo.nickName ?? "", coinName: coinName.name)
                    
                    UserViewModel.shared.fetchUserInfo()
                    
                    DispatchQueue.main.async {
                        self.coinViewModel.filterBookmarkedCoinData()
                        self.updateStatusLabel()
                    }
                    
                } catch {
                    print("Delete: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.coinViewModel.bookmarkedCoinData.insert(coinName, at: indexPath.row)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        } else {
            print("Delete: 유저정보가 존재하지 않습니다.")
        }
    }
}
