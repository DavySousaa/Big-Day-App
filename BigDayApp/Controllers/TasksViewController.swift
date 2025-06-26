//
//  TasksViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class TasksViewController: UIViewController, UITextFieldDelegate {

   var taskSreen = TaskScreen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = taskSreen
        view.backgroundColor = .green
        navigationItem.hidesBackButton = true

    }
}

