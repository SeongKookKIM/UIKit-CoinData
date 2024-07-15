//
//  EditProfileViewController.swift
//  CoinApp
//
//  Created by SeongKook on 7/15/24.
//

import UIKit
import Combine

class EditProfileViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        self.title = "회원정보 수정"
        self.view.backgroundColor = .white
    }


}
