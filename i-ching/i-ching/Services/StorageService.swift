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
}


