//
//  NotificationsViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = notifications
        view.backgroundColor = UIColor(named: "PrimaryColor")
        
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Notificações"
    }
}
