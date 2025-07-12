//
//  AboutViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

class AboutViewController: UIViewController {
    
    var about = About()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = about
        view.backgroundColor = UIColor(named: "PrimaryColor")
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Sobre o App"
    }
    
}
