import Foundation

class StorageService {
    static let shared = StorageService()
    private let readingsKey = "saved_readings"
    
    private init() {}
    
    func saveReading(_ reading: Reading) {
        var readings = loadReadings()
        readings.append(reading)
        
        do {
            let encoded = try JSONEncoder().encode(readings)
            UserDefaults.standard.set(encoded, forKey: readingsKey)
        } catch {
            print("Ошибка сохранения расклада: \(error.localizedDescription)")
        }
    }
    
    func loadReadings() -> [Reading] {
        guard let data = UserDefaults.standard.data(forKey: readingsKey),
              let readings = try? JSONDecoder().decode([Reading].self, from: data) else {
            return []
        }
        return readings
    }
    
    func deleteReading(_ reading: Reading) {
        var readings = loadReadings()
        readings.removeAll { $0.id == reading.id }
        
        do {
            let encoded = try JSONEncoder().encode(readings)
            UserDefaults.standard.set(encoded, forKey: readingsKey)
        } catch {
            print("Ошибка удаления расклада: \(error.localizedDescription)")
        }
    }
    
    func updateReading(_ reading: Reading) {
        var readings = loadReadings()
        if let index = readings.firstIndex(where: { $0.id == reading.id }) {
            readings[index] = reading
            
            do {
                let encoded = try JSONEncoder().encode(readings)
                UserDefaults.standard.set(encoded, forKey: readingsKey)
            } catch {
                print("Ошибка обновления расклада: \(error.localizedDescription)")
            }
        }
    }
    
    func filterReadings(byTag tag: String?) -> [Reading] {
        let readings = loadReadings()
        guard let tag = tag, !tag.isEmpty else {
            return readings
        }
        return readings.filter { reading in
            reading.tags?.contains(tag) ?? false
        }
    }
    
    // MARK: - Daily Sign Methods
    
    private let dailySignDateKey = "daily_sign_date"
    private let dailySignHexagramKey = "daily_sign_hexagram"
    private let dailySignLinesKey = "daily_sign_lines"
    private let dailySignLockKey = "daily_sign_lock"
    
    /// Блокирует возможность получения знака дня на сегодня (вызывается при начале генерации)
    func lockDailySignForToday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let todayString = formatter.string(from: Date())
        UserDefaults.standard.set(todayString, forKey: dailySignLockKey)
        UserDefaults.standard.synchronize()
    }
    
    /// Проверяет, заблокирован ли знак дня (даже если ещё не полностью сохранен)
    func isDailySignLocked() -> Bool {
        UserDefaults.standard.synchronize()
        guard let lockDateString = UserDefaults.standard.string(forKey: dailySignLockKey) else {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        guard let lockDate = formatter.date(from: lockDateString) else {
            return false
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lockDay = Calendar.current.startOfDay(for: lockDate)
        
        return Calendar.current.isDate(today, inSameDayAs: lockDay)
    }
    
    /// Проверяет, был ли уже получен знак дня сегодня
    func hasDailySignForToday() -> Bool {
        // Синхронизируем UserDefaults перед чтением, чтобы получить актуальные данные
        UserDefaults.standard.synchronize()
        
        // Проверяем блокировку (это быстрее и надежнее)
        if isDailySignLocked() {
            return true
        }
        
        guard let savedDateString = UserDefaults.standard.string(forKey: dailySignDateKey) else {
            return false
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        guard let savedDate = formatter.date(from: savedDateString) else {
            return false
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let savedDay = Calendar.current.startOfDay(for: savedDate)
        
        return Calendar.current.isDate(today, inSameDayAs: savedDay)
    }
    
    /// Сохраняет знак дня
    func saveDailySign(hexagram: Hexagram, lines: [Line]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let todayString = formatter.string(from: Date())
        
        // Сохраняем дату ПЕРВОЙ, чтобы заблокировать повторные попытки
        UserDefaults.standard.set(todayString, forKey: dailySignDateKey)
        UserDefaults.standard.set(hexagram.number, forKey: dailySignHexagramKey)
        
        // Сохраняем линии
        let linesData = lines.map { [
            "isYang": $0.isYang,
            "isChanging": $0.isChanging,
            "position": $0.position
        ] as [String: Any] }
        
        UserDefaults.standard.set(linesData, forKey: dailySignLinesKey)
        
        // Блокировка уже установлена при начале генерации, но убедимся
        UserDefaults.standard.set(todayString, forKey: dailySignLockKey)
        
        // Синхронизируем UserDefaults немедленно, чтобы сохранить данные
        UserDefaults.standard.synchronize()
    }
    
    /// Загружает знак дня
    func loadDailySign() -> (hexagram: Hexagram, lines: [Line])? {
        print("📥 loadDailySign() вызвана")
        
        guard hasDailySignForToday() else {
            print("❌ loadDailySign: hasDailySignForToday() вернул false")
            return nil
        }
        
        let hexagramNumber = UserDefaults.standard.integer(forKey: dailySignHexagramKey)
        print("📊 loadDailySign: hexagramNumber = \(hexagramNumber)")
        
        guard let hexagram = Hexagram.findByNumber(hexagramNumber) else {
            print("❌ loadDailySign: Hexagram.findByNumber(\(hexagramNumber)) вернул nil")
            return nil
        }
        
        print("✅ loadDailySign: гексаграмма найдена: \(hexagram.number) - \(hexagram.name)")
        
        guard let linesData = UserDefaults.standard.array(forKey: dailySignLinesKey) as? [[String: Any]] else {
            print("❌ loadDailySign: не удалось загрузить linesData из UserDefaults")
            return nil
        }
        
        print("📊 loadDailySign: linesData.count = \(linesData.count)")
        
        let lines = linesData.compactMap { dict -> Line? in
            guard let isYang = dict["isYang"] as? Bool,
                  let isChanging = dict["isChanging"] as? Bool,
                  let position = dict["position"] as? Int else {
                return nil
            }
            return Line(isYang: isYang, isChanging: isChanging, position: position)
        }
        
        print("📊 loadDailySign: lines.count = \(lines.count)")
        
        guard lines.count == 6 else {
            print("❌ loadDailySign: lines.count = \(lines.count), ожидалось 6")
            return nil
        }
        
        print("✅ loadDailySign: успешно загружен знак дня")
        return (hexagram, lines)
    }
    
    /// Сбрасывает знак дня (для отладки и сброса)
    func resetDailySign() {
        UserDefaults.standard.removeObject(forKey: dailySignDateKey)
        UserDefaults.standard.removeObject(forKey: dailySignHexagramKey)
        UserDefaults.standard.removeObject(forKey: dailySignLinesKey)
        UserDefaults.standard.removeObject(forKey: dailySignLockKey)
        UserDefaults.standard.synchronize()
    }
}


