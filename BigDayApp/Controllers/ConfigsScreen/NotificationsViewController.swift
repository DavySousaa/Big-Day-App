//
//  NotificationsViewController.swift
//  BigDayApp
//
//  Created by Davy Sousa on 12/07/25.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    var notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavgatioBar()
        self.view = notifications
        view.backgroundColor = UIColor(named: "PrimaryColor")
        notifications.delegate = self
    }
    
    private func setupNavgatioBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = "Notificações"
    }
    
    func mostrarAlertaIrParaAjustes() {
        let alert = UIAlertController(
            title: "Tem certeza?",
            message: "Se quiser desativar completamente, vá até os Ajustes do sistema.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
            self.notifications.switchPicker.isOn = true
        }))
        alert.addAction(UIAlertAction(title: "Abrir Ajustes", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        
        self.present(alert, animated: true)
    }
}

extension NotificationsViewController: NotificationDelete {
    func switchOff(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        print("✅ Notificações ativadas")
                    } else {
                        print("❌ Usuário recusou")
                        sender.setOn(false, animated: true)
                        self.mostrarAlertaIrParaAjustes()
                    }
                }
            }
        } else {
            mostrarAlertaIrParaAjustes()
        }
    }
}
