//
//  NavigationSetup.swift
//  BigDayApp
//
//  Created by Davy Sousa on 17/07/25.
//

import UIKit

extension UIViewController {
    
    func navigationSetup(title: String) {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = title
    }
    
    func navigationSetupWithLogo(title: String) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = title
        
        let logoImage = traitCollection.userInterfaceStyle == .dark
        ? UIImage(named: "logo2")
        : UIImage(named: "logo1")
        
        let imageView = UIImageView(image: logoImage)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.frame = logoContainer.bounds
        logoContainer.addSubview(imageView)
        
        let logoItem = UIBarButtonItem(customView: logoContainer)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 14
        
        navigationItem.leftBarButtonItems = [spacer, logoItem]
    }
}
