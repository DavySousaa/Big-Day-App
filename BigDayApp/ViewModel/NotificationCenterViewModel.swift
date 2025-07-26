//
//  NotificcationCenterViewModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 25/07/25.
//

import UIKit

final class NotificationCenterViewModel {
    
    var onSettingsRequired: (() -> Void)?
    var onPermissionGranted: (() -> Void)?
    var onPermissionDenied: (() -> Void)?
    
    
    func handleNotificationToggle(isOn: Bool) {
        if isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        self.onPermissionGranted?()
                    } else {
                        self.onPermissionDenied?()
                        self.onSettingsRequired?()
                    }
                }
            }
        } else {
            self.onSettingsRequired?()
        }
    }
}
