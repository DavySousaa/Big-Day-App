//
//  NotificationsViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var notifications = Notifications()
    var viewModel = NotificationCenterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup(title: "Notificações")
        self.view = notifications
        view.backgroundColor = UIColor(named: "PrimaryColor")
        notifications.delegate = self
        blindViewModel()
    }
    
    private func blindViewModel() {
        viewModel.onPermissionDenied = { [weak self] in
            
        }
        viewModel.onPermissionGranted = { [weak self] in
            self?.notifications.switchPicker.setOn(false, animated: true)
        }
        viewModel.onSettingsRequired = { [weak self] in
            self?.showAlertToOpenSettings()
        }
    }
    
    private func showAlertToOpenSettings() {
            let alert = UIAlertController(
                title: "Tem certeza?",
                message: "Se quiser desativar completamente, vá até os Ajustes do sistema.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
                self.notifications.switchPicker.setOn(true, animated: true)
            }))

            alert.addAction(UIAlertAction(title: "Abrir Ajustes", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))

            present(alert, animated: true)
        }
}

extension NotificationsViewController: NotificationDelete {
    func switchOff(_ sender: UISwitch) {
        viewModel.handleNotificationToggle(isOn: sender.isOn)
    }
}
