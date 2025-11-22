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
        moveIndicator(to: selectedIndex)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        moveIndicator(to: index)
    }
    
    private func moveIndicator(to index: Int) {
        guard let items = tabBar.items, !items.isEmpty else { return }
        
        let tabBarItemCount = CGFloat(items.count)
        let tabBarItemWidth = tabBar.frame.width / tabBarItemCount
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: {
            self.tabBar.layoutIfNeeded()
        })
    }
    

    private func setupTabBar() {
        let tarefasVC = UINavigationController(rootViewController: TasksViewController())
        tarefasVC.tabBarItem = UITabBarItem(
            title: "Tarefas",
            image: UIImage(systemName: "checkmark.circle"),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")
        )
        
        let listaVc = UINavigationController(rootViewController: ListsViewController())
        listaVc.tabBarItem = UITabBarItem(
            title: "Listas",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle")
        )
        
        let compartilharVC = UINavigationController(rootViewController: ShareTasksViewController())
        compartilharVC.tabBarItem = UITabBarItem(
            title: "Compartilhar",
            image: UIImage(systemName: "square.and.arrow.up"),
            selectedImage: UIImage(systemName: "square.and.arrow.up.fill")
        )
        
        let configVC = UINavigationController(rootViewController: ConfigViewController())
        configVC.tabBarItem = UITabBarItem(
            title: "Config",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        viewControllers = [tarefasVC, compartilharVC, listaVc, configVC]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Fundo mais “glass”
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.9)
        
        // Cor dos ícones / textos
        appearance.stackedLayoutAppearance.normal.iconColor = .secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.secondaryLabel,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = ColorSuport.greenApp
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: ColorSuport.greenApp,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = ColorSuport.greenApp
        tabBar.unselectedItemTintColor = .secondaryLabel
        tabBar.isTranslucent = true
        
        // Cantos arredondados e “card” flutuante
        tabBar.layer.cornerRadius = 24
        tabBar.layer.masksToBounds = true
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
        
    }
}

