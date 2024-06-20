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
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var filterCoinData: [CoinModel] = []
    
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
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinViewModel.fetchCoinData()
        
        setUpUI()
        setUpBindData()
        setupSearchController()
    }
    
    // UI Update
    func setUpUI() {
        self.title = "Coin List"
        self.view.backgroundColor = .white
        

        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
         

    }
    
    // Combine Data Binding
    /*
     private func setUpBindData() {
         coinViewModel.$coinData
             .receive(on: DispatchQueue.main)
             .sink { [weak self] _ in
                 self?.tableView.reloadData()
             }
             .store(in: &cancellables)
         
         coinViewModel.$isLoading
             .receive(on: DispatchQueue.main)
             .sink { [weak self] isLoading in
                 if isLoading {
                     self?.activityIndicator.startAnimating()
                 } else {
                     self?.activityIndicator.stopAnimating()
                 }
             }
             .store(in: &cancellables)
     }
     */

    private func setUpBindData() {
        Publishers.CombineLatest(coinViewModel.$coinData, coinViewModel.$isLoading)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coinData, isLoading in
                self?.tableView.reloadData()
                
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    // Search
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "코인이름을 검색해주세요."
         navigationItem.searchController = searchController
//        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    // Search Update
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filterCoinData = coinViewModel.coinData
            tableView.reloadData()
            return
        }
        filterCoinData.removeAll()
        
        let lowercasedSearchText = searchText.lowercased()
        filterCoinData = coinViewModel.coinData.filter { coin in
            return coin.name.lowercased().contains(lowercasedSearchText) ||
                   coin.symbol.lowercased().contains(lowercasedSearchText) ||
                   String(format: "%.2f", coin.quotes.krw.price).contains(lowercasedSearchText)
        }
        tableView.reloadData()
    }
}

// TableViewDataSource, TableViewDelegate 분리
extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filterCoinData.count
        }
        return coinViewModel.coinData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "coinListCell", for: indexPath) as? CointListTVCell else {
            return UITableViewCell()
        }
        
        let coinCell: CoinModel
        
        if searchController.isActive {
            coinCell = filterCoinData[indexPath.row]
        } else {
            coinCell = coinViewModel.coinData[indexPath.row]
        }
        
        cell.selectionStyle = .none
        cell.configure(item: coinCell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoinCell: CoinModel
        
        if searchController.isActive {
            selectedCoinCell = filterCoinData[indexPath.row]
        } else {
            selectedCoinCell = coinViewModel.coinData[indexPath.row]
        }
        
        let coinDetailViewController = CoinDetailViewController(coindata: selectedCoinCell)
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
