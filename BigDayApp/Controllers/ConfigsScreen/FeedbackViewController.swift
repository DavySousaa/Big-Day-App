//
//  FeedbackViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    var feedBack = FeedBack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = feedBack
        view.backgroundColor = UIColor(named: "PrimaryColor")

    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "FeedBack"
    }
    
}
