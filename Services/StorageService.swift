import Foundation

class StorageService {
    static let shared = StorageService()
    private let readingsKey = "saved_readings"
    
    private init() {}
    
    func saveReading(_ reading: Reading) {
        var readings = loadReadings()
        readings.append(reading)
        
        if let encoded = try? JSONEncoder().encode(readings) {
            UserDefaults.standard.set(encoded, forKey: readingsKey)
        }
    }
    
    func loadReadings() -> [Reading] {
        guard let data = UserDefaults.standard.data(forKey: readingsKey),
              let readings = try? JSONDecoder().decode([Reading].self, from: data) else {
            return []
        }
        return readings
    }
}


