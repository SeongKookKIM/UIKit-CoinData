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
    
    private var bookmarkImage: UIImageView = {
        let bookmarkImage = UIImageView(image: UIImage(systemName: "bookmark"))
        bookmarkImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        bookmarkImage.tintColor = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        bookmarkImage.contentMode = .scaleAspectFill
        bookmarkImage.translatesAutoresizingMaskIntoConstraints = false
        
        return bookmarkImage
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // setupUI
    func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(bookmarkImage)
        setupLayout()
    }
    
    // setupLayout
    func setupLayout() {
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
