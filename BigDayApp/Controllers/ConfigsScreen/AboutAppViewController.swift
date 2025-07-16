//
//  AboutViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

class AboutAppViewController: UIViewController {

    var aboutAppView = AboutAppView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = aboutAppView
        title = "Sobre o App"
        view.backgroundColor = UIColor(named: "PrimaryColor")
    }
}
