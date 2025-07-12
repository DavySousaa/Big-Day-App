//
//  changeNickName.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//
import UIKit


class Notifications: UIView {
    
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notifications: SetupLayout {
    func addSubViews() {
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    func setupStyle() {
        
    }
}
