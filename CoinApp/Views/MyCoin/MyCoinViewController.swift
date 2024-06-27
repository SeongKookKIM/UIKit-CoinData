//
//  MyCoinViewController.swift
//  CoinApp
//
//  Created by SeongKook on 6/25/24.
//

import UIKit

class MyCoinViewController: UIViewController {
    
    private lazy var testALabel = UILabel()
    private lazy var testBLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if let accessToken = KeychainHelper.shared.get("accessToken") {
            testALabel.text = accessToken
        } else {
            testALabel.text = "accessToken none"
        }

        if let refreshToken = KeychainHelper.shared.get("refreshToken") {
            testBLabel.text = refreshToken
        } else {
            testBLabel.text = "refreshToken none"
        }
        
        testALabel.translatesAutoresizingMaskIntoConstraints = false
        testBLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(testALabel)
        self.view.addSubview(testBLabel)
        
        NSLayoutConstraint.activate([
            testALabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testALabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            testBLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testBLabel.topAnchor.constraint(equalTo: testALabel.bottomAnchor, constant: 40),
        ])

    }
    


}
