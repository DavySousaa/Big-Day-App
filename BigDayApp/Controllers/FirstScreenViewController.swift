//
//  FirstScreen.swift
//  BigDayApp
//
//  Created by Davy Sousa on 02/06/25.
//

import UIKit

class FirstScreenViewController: UIViewController {

   var firstScreen = FirstScreen()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = firstScreen
        view.backgroundColor = .white
    }
    
}
