//
//  CointListTVCell.swift
//  CoinApp
//
//  Created by SeongKook on 6/18/24.
//

import UIKit

class CointListTVCell: UITableViewCell {
    
    private var coinViewModel = CoinViewModel()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return priceLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // congifure
    func configure(item: CoinModel) {
        nameLabel.text = "\(item.name)(\(item.symbol))"
        priceLabel.text = "\(coinViewModel.priceInt(item.quotes.krw.price))원"
    }

}
