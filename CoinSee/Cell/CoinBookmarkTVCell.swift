//
//  CointListTVCell.swift
//  CoinApp
//
//  Created by SeongKook on 6/18/24.
//

import UIKit

class CoinBookmarkTVCell: UITableViewCell {
    
    private var coinViewModel = CoinViewModel()
    
    private let nameLabel: UILabel = {
        return UILabel.basicLabel(fontSize: 20, fontWeight: .bold)
    }()
    
    private let priceLabel: UILabel = {
        return UILabel.basicLabel(fontSize: 18, fontWeight: .regular)
    }()
    
    private var bookmarkImage: UIImageView = {
        return UIImageView.bookmarkImage(imageName: "bookmark")
    }()

    
    // 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // setupUI
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(bookmarkImage)
        setupLayout()
    }
    
    // setupLayout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            bookmarkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmarkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // congifure
    func configure(item: CoinModel, checkBookmark: [String]) {
        nameLabel.text = "\(item.name)(\(item.symbol))"
        priceLabel.text = "\(item.quotes.krw.price.priceInt())원"
        
        if checkBookmark.contains(item.name) {
            DispatchQueue.main.async {
                self.bookmarkImage.image = UIImage(systemName: "bookmark.fill")
            }
        } else {
            DispatchQueue.main.async {
                self.bookmarkImage.image = UIImage(systemName: "bookmark")
            }
        }
    }

}
