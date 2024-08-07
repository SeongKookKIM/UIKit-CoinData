//
//  ViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/17/24.
//

import UIKit
import Combine

class CoinListViewController: UIViewController, UISearchResultsUpdating {
    
    private var coinViewModel = CoinViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshCoinDataController = UIRefreshControl()
    
    // Bookmark List
    var bookmarkList: [String] = []
    
    // tableView
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CointListTVCell.self, forCellReuseIdentifier: "coinListCell")
        
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
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindData()
        setupSearchController()
        setupBarButtonItem()
        setupRefreshData()
        
        UserViewModel.shared.fetchUserInfo()
    }
        
    // UI Update
    private func setupUI() {
        self.title = "Coin List"
        self.view.backgroundColor = .systemBackground
        self.view.accessibilityIdentifier = "CoinListView"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        self.view.addSubview(errorLabel)
        
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
            errorLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    // setup BindData
    private func setupBindData() {
        coinViewModel.$coinData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.tableView.isHidden = false
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        coinViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.isHidden = true
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
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("북마크 에러 발생: \(error.localizedDescription)")
                        }
                    }
                } else {
                    self.bookmarkList = []
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
    }
    
    // Search
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "코인이름을 검색해주세요."
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // Search Update
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        coinViewModel.searchCoinData(with: searchText)
        self.tableView.reloadData()
    }
    
    // setup UIBarButton
    private func setupBarButtonItem() {
        let image = UIImage(systemName: "arrow.clockwise")
        let updateDataButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(handlerUpdateData))
        updateDataButton.tintColor = UIColor(named: "TabBarColor")
                
        self.navigationItem.rightBarButtonItem = updateDataButton
    }
    
    // handlerUpdateData
    @objc func handlerUpdateData() {
        coinViewModel.updateCoinData()
    }
    
    // refresh Data
    private func setupRefreshData() {
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
extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TableView Cell갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return coinViewModel.filteredCoinData.count
        }
        return coinViewModel.coinData.count
    }
    
    // TableView Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinListCell", for: indexPath) as? CointListTVCell else {
            return UITableViewCell()
        }
        
        let coinCell: CoinModel
        
        if searchController.isActive {
            coinCell = coinViewModel.filteredCoinData[indexPath.row]
        } else {
            coinCell = coinViewModel.coinData[indexPath.row]
        }
        
        cell.selectionStyle = .none
        cell.configure(item: coinCell, checkBookmark: bookmarkList)
        
        return cell
        
    }
    
    // TableView Click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoinCell: CoinModel
        let isBookmarkSelected = false
        
        if searchController.isActive {
            selectedCoinCell = coinViewModel.filteredCoinData[indexPath.row]
        } else {
            selectedCoinCell = coinViewModel.coinData[indexPath.row]
        }
        
        let coinDetailViewController = CoinDetailViewController(coindata: selectedCoinCell, isBookmarkSelected: isBookmarkSelected)
        coinDetailViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = coinDetailViewController.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { context in
                    return context.maximumDetentValue * 0.878912
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
