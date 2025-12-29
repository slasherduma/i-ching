import Foundation

struct Hexagram: Codable, Identifiable {
    let id: Int
    let number: Int
    let name: String
    let interpretation: String
    let character: String
    
    static func loadAll() -> [Hexagram] {
        guard let url = Bundle.main.url(forResource: "hexagrams", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let hexagrams = try? JSONDecoder().decode([Hexagram].self, from: data) else {
            return []
        }
        return hexagrams
    }
    
    static func find(byLines lines: [Line]) -> Hexagram? {
        let hexagrams = loadAll()
        // Линии идут снизу вверх (position 1-6)
        // Для бинарного представления читаем снизу вверх (position 1 = младший бит)
        let sortedLines = lines.sorted { $0.position < $1.position }
        let binary = sortedLines.map { $0.isYang ? "1" : "0" }.joined()
        // Преобразуем бинарное число в десятичное и добавляем 1 для соответствия нумерации
        let number = Int(binary, radix: 2)! + 1
        // Ограничиваем номер диапазоном 1-64
        let validNumber = min(max(number, 1), 64)
        return hexagrams.first { $0.number == validNumber }
    }
}

struct Line: Identifiable {
    let id = UUID()
    let isYang: Bool
    let isChanging: Bool
    let position: Int // 1-6, снизу вверх
}

struct Reading: Codable, Identifiable {
    let id: String
    let date: Date
    let question: String?
    let hexagramNumber: Int
    let hexagramName: String
    let lines: [LineData]
    let interpretation: String
    
    struct LineData: Codable {
        let isYang: Bool
        let isChanging: Bool
        let position: Int
    }
    
    var uuid: UUID {
        UUID(uuidString: id) ?? UUID()
    }
    
    init(date: Date, question: String?, hexagram: Hexagram, lines: [Line]) {
        self.id = UUID().uuidString
        self.date = date
        self.question = question
        self.hexagramNumber = hexagram.number
        self.hexagramName = hexagram.name
        self.lines = lines.map { LineData(isYang: $0.isYang, isChanging: $0.isChanging, position: $0.position) }
        self.interpretation = hexagram.interpretation
    }
}

