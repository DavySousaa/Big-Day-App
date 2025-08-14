import UserNotifications

final class NotificationCenterViewModel {
    var onSettingsRequired: (() -> Void)?
    var onPermissionGranted: (() -> Void)?
    var onPermissionDenied: (() -> Void)?
    
    func syncPermissionState() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            let enabled = (settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional)
                        && (settings.alertSetting == .enabled || settings.soundSetting == .enabled || settings.badgeSetting == .enabled)
            DispatchQueue.main.async {
                enabled ? self?.onPermissionGranted?() : self?.onPermissionDenied?()
            }
        }
    }
    
    func handleNotificationToggle(isOn: Bool) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self else { return }
            
            switch settings.authorizationStatus {
            case .notDetermined:
                if isOn {
                    self.requestPermission()
                } else {
                    DispatchQueue.main.async { self.onPermissionDenied?() }
                }
                
            case .denied:
                DispatchQueue.main.async {
                    self.onPermissionDenied?()
                    self.onSettingsRequired?()
                }
                
            case .authorized, .provisional, .ephemeral:
                if isOn {
                    DispatchQueue.main.async { self.onPermissionGranted?() }
                } else {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    DispatchQueue.main.async { self.onPermissionDenied?() }
                }
                
            @unknown default:
                DispatchQueue.main.async { self.onPermissionDenied?() }
            }
        }
    }
    
    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                if granted {
                    self.onPermissionGranted?()
                } else {
                    self.onPermissionDenied?()
                    self.onSettingsRequired?()
                }
            }
        }
    }
}

