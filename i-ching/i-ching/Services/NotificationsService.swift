import Foundation
import UserNotifications
import Combine

enum NotificationFrequency: String, Codable {
    case daily = "ежедневно"
    case weekly = "раз в неделю"
    case off = "выключено"
}

class NotificationsService: NSObject, ObservableObject {
    static let shared = NotificationsService()
    
    @Published var frequency: NotificationFrequency
    @Published var notificationTime: Date
    
    private override init() {
        // Загружаем настройки
        if let savedFrequency = UserDefaults.standard.string(forKey: "notificationFrequency"),
           let freq = NotificationFrequency(rawValue: savedFrequency) {
            self.frequency = freq
        } else {
            self.frequency = .off
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            self.notificationTime = savedTime
        } else {
            // По умолчанию 9:00
            var components = DateComponents()
            components.hour = 9
            components.minute = 0
            self.notificationTime = Calendar.current.date(from: components) ?? Date()
        }
        
        super.init()
        
        // Настраиваем наблюдатели для @Published свойств
        setupObservers()
        
        // Запрашиваем разрешение
        requestAuthorization()
    }
    
    private func setupObservers() {
        $frequency
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue.rawValue, forKey: "notificationFrequency")
                self?.updateNotifications()
            }
            .store(in: &cancellables)
        
        $notificationTime
            .dropFirst()
            .sink { [weak self] newValue in
                UserDefaults.standard.set(newValue, forKey: "notificationTime")
                self?.updateNotifications()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.updateNotifications()
                }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func updateNotifications() {
        // Удаляем все существующие уведомления
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard frequency != .off else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Знак дня"
        content.body = "Хочешь получить знак на день?"
        content.sound = .default
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        if frequency == .daily {
            // Ежедневно в указанное время
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "dailySign",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request)
        } else if frequency == .weekly {
            // Раз в неделю (понедельник)
            dateComponents.weekday = 2 // Понедельник
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "weeklySign",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(request)
        }
    }
}

extension NotificationsService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Показываем уведомление даже когда приложение открыто
        completionHandler([.banner, .sound])
    }
}

