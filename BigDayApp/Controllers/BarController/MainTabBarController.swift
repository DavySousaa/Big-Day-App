//
//  MainTabBarController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
           super.viewDidLoad()
           setupTabBar()
       }
    
    private func setupTabBar() {
        let tarefasVC = UINavigationController(rootViewController: TasksViewController())
        tarefasVC.tabBarItem = UITabBarItem(title: "Tarefas", image: UIImage(systemName: "checkmark.circle"), tag: 0)
        
        let compartilharVC = UINavigationController(rootViewController: ShareTasksViewController())
        compartilharVC.tabBarItem = UITabBarItem(title: "Compartilhar", image: UIImage(systemName: "square.and.arrow.up"), tag: 1)
        
        let configVC = UINavigationController(rootViewController: ConfigViewController())
        configVC.tabBarItem = UITabBarItem(title: "Configurações", image: UIImage(systemName: "gearshape"), tag: 2)

        viewControllers = [tarefasVC, compartilharVC, configVC]
        tabBar.tintColor = .label
        tabBar.backgroundColor = UIColor(named: "PrimaryColor")
    }
}

