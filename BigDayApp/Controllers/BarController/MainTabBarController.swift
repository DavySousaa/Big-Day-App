//
//  MainTabBarController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    private var indicatorLeadingConstraint: NSLayoutConstraint!
    private var indicatorWidthConstraint: NSLayoutConstraint!
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSuport.greenApp
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        moveIndicator(to: selectedIndex)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        moveIndicator(to: index)
    }
    
    private func moveIndicator(to index: Int) {
        let tabBarItemCount = CGFloat(tabBar.items?.count ?? 1)
        let tabBarItemWidth = tabBar.frame.width / tabBarItemCount
        let newLeading = tabBarItemWidth * CGFloat(index)
        
        indicatorLeadingConstraint.constant = newLeading
        
        UIView.animate(withDuration: 0.25) {
            self.tabBar.layoutIfNeeded()
        }
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
        
       
        tabBar.addSubview(indicatorView)
        tabBar.addSubview(indicatorView)
        
        let tabBarItemCount = CGFloat(tabBar.items?.count ?? 1)
        let tabBarItemWidth = tabBar.frame.width / tabBarItemCount
        
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor)
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: tabBarItemWidth)
        
        NSLayoutConstraint.activate([
            indicatorView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorLeadingConstraint,
            indicatorWidthConstraint
        ])
        
    }
}

