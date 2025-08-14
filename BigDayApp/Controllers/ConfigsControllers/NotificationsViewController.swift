import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    
    var notifications = Notifications() // sua view custom com o switchPicker
    var viewModel = NotificationCenterViewModel()
    
    private var isUpdatingSwitch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup(title: "Notificações")
        view = notifications
        view.backgroundColor = UIColor(named: "PrimaryColor")
        notifications.delegate = self
        bindViewModel()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appCameBack),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncSwitchWithSystem()
    }
    
    @objc private func appCameBack() {
        syncSwitchWithSystem()
    }
    
    private func bindViewModel() {
        viewModel.onPermissionDenied = { [weak self] in
            self?.setSwitchOn(false)
        }
        viewModel.onPermissionGranted = { [weak self] in
            self?.setSwitchOn(true)
        }
        viewModel.onSettingsRequired = { [weak self] in
            self?.showAlertToOpenSettings()
        }
    }
    
    private func setSwitchOn(_ isOn: Bool, animated: Bool = true) {
        isUpdatingSwitch = true
        notifications.switchPicker.setOn(isOn, animated: animated)
        isUpdatingSwitch = false
    }
    
    private func syncSwitchWithSystem() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            let enabled = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
                        && (settings.alertSetting == .enabled || settings.soundSetting == .enabled || settings.badgeSetting == .enabled)
            DispatchQueue.main.async {
                self?.setSwitchOn(enabled, animated: false)
            }
        }
    }
    
    private func showAlertToOpenSettings() {
        let alert = UIAlertController(
            title: "Tem certeza?",
            message: "Para desativar completamente, vá em Ajustes > Notificações > Big Day.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { [weak self] _ in
            self?.setSwitchOn(true)
        }))
        alert.addAction(UIAlertAction(title: "Abrir Ajustes", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        present(alert, animated: true)
    }
}

extension NotificationsViewController: NotificationDelete { // talvez "NotificationDelegate"?
    func switchOff(_ sender: UISwitch) {
        // Evita loop quando setamos programaticamente
        if isUpdatingSwitch { return }
        viewModel.handleNotificationToggle(isOn: sender.isOn)
    }
}

