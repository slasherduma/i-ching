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
            // По умолчанию ежедневные уведомления включены
            self.frequency = .daily
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
        
        // Проверяем, был ли уже запрос разрешений
        checkAndRequestAuthorization()
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
    
    /// Проверяет статус разрешений и запрашивает их при первом запуске
    func checkAndRequestAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Разрешение еще не запрашивалось - запрашиваем при первом запуске
                DispatchQueue.main.async {
                    self.requestAuthorization()
                }
            case .authorized, .provisional, .ephemeral:
                // Разрешение уже есть - обновляем уведомления
                DispatchQueue.main.async {
                    self.updateNotifications()
                }
            case .denied:
                // Пользователь отклонил разрешение
                print("Разрешение на уведомления отклонено")
            @unknown default:
                break
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка при запросе разрешения на уведомления: \(error.localizedDescription)")
                return
            }
            
            if granted {
                print("✅ Разрешение на уведомления получено")
                DispatchQueue.main.async {
                    self.updateNotifications()
                }
            } else {
                print("❌ Разрешение на уведомления отклонено")
            }
        }
    }
    
    func updateNotifications() {
        // Удаляем все существующие уведомления
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard frequency != .off else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Знак дня"
        content.body = "Доступен новый знак дня!"
        content.sound = .default
        content.userInfo = ["type": "dailySign"] // Добавляем информацию для обработки нажатия
        content.categoryIdentifier = "DAILY_SIGN_CATEGORY" // Категория для действий
        
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
    
    // MARK: - Test Methods
    
    /// Создает тестовое уведомление, которое сработает через указанное количество секунд
    /// Используйте этот метод для быстрого тестирования уведомлений
    func scheduleTestNotification(in seconds: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = "Знак дня"
        content.body = "Доступен новый знак дня! (тестовое уведомление)"
        content.sound = .default
        content.userInfo = ["type": "dailySign"]
        content.categoryIdentifier = "DAILY_SIGN_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(
            identifier: "testDailySign",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при создании тестового уведомления: \(error.localizedDescription)")
            } else {
                print("Тестовое уведомление запланировано на \(seconds) секунд")
            }
        }
    }
    
    /// Создает ежедневное уведомление, которое сработает через указанное количество минут от текущего времени
    /// Используется для тестирования ежедневных уведомлений на ближайшее время
    func scheduleDailyNotificationInMinutes(_ minutes: Int) {
        let calendar = Calendar.current
        let now = Date()
        
        // Добавляем небольшую задержку (5 секунд), чтобы компенсировать время выполнения кода
        // и гарантировать, что уведомление сработает после заданного времени
        let adjustmentSeconds: TimeInterval = 5
        guard let adjustedNow = calendar.date(byAdding: .second, value: Int(adjustmentSeconds), to: now) else {
            print("Ошибка: не удалось вычислить время")
            return
        }
        
        // Вычисляем время через указанное количество минут
        guard let targetTime = calendar.date(byAdding: .minute, value: minutes, to: adjustedNow) else {
            print("Ошибка: не удалось вычислить время")
            return
        }
        
        let hour = calendar.component(.hour, from: targetTime)
        let minute = calendar.component(.minute, from: targetTime)
        
        print("🕐 Настраиваем ежедневное уведомление на \(hour):\(String(format: "%02d", minute)) (примерно через \(minutes) минут)")
        print("   Текущее время: \(DateFormatter.localizedString(from: now, dateStyle: .none, timeStyle: .medium))")
        print("   Целевое время: \(DateFormatter.localizedString(from: targetTime, dateStyle: .none, timeStyle: .medium))")
        
        // Устанавливаем время в настройках
        self.notificationTime = targetTime
        self.frequency = .daily
        
        // Принудительно обновляем уведомления
        self.updateNotifications()
        
        print("✅ Ежедневное уведомление запланировано")
    }
    
    /// Показывает все запланированные уведомления в консоли (для отладки)
    func printPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("=== Запланированные уведомления ===")
            if requests.isEmpty {
                print("Нет запланированных уведомлений")
            } else {
                for request in requests {
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                        let components = trigger.dateComponents
                        print("ID: \(request.identifier)")
                        print("  Заголовок: \(request.content.title)")
                        print("  Текст: \(request.content.body)")
                        if let hour = components.hour, let minute = components.minute {
                            print("  Время: \(hour):\(String(format: "%02d", minute))")
                        } else {
                            print("  Время: не указано")
                        }
                        if let weekday = components.weekday {
                            let weekdays = ["", "Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
                            print("  День недели: \(weekdays[weekday])")
                        }
                        print("  Повторяется: \(trigger.repeats)")
                        
                        // Показываем, когда сработает следующее уведомление
                        if let nextDate = trigger.nextTriggerDate() {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "ru_RU")
                            formatter.dateStyle = .medium
                            formatter.timeStyle = .short
                            print("  Следующее уведомление: \(formatter.string(from: nextDate))")
                        }
                        print("---")
                    } else if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                        print("ID: \(request.identifier)")
                        print("  Заголовок: \(request.content.title)")
                        print("  Текст: \(request.content.body)")
                        print("  Через: \(trigger.timeInterval) секунд")
                        if let nextDate = trigger.nextTriggerDate() {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "ru_RU")
                            formatter.dateStyle = .medium
                            formatter.timeStyle = .short
                            print("  Сработает: \(formatter.string(from: nextDate))")
                        }
                        print("---")
                    }
                }
            }
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
    
    // Обработка нажатия на уведомление
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("📬 Получено нажатие на уведомление")
        print("   UserInfo: \(userInfo)")
        
        // Проверяем, что это уведомление о знаке дня
        if let type = userInfo["type"] as? String, type == "dailySign" {
            print("✅ Это уведомление о знаке дня - отправляем событие для открытия экрана")
            // Отправляем уведомление через NotificationCenter, чтобы StartView мог открыть DailySignView
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("OpenDailySign"), object: nil)
            }
        } else {
            print("⚠️ Тип уведомления не распознан")
        }
        
        completionHandler()
    }
}

