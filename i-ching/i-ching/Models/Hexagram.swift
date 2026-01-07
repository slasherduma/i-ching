import Foundation

struct Trigram: Codable, Hashable {
    let name: String
    let description: String
}

struct Hexagram: Codable, Identifiable, Hashable {
    let id: Int
    let number: Int
    let name: String
    let interpretation: String
    let character: String
    
    // Новые стабильные поля
    let keyPhrase: String?
    let image: String? // Описание образа: "небо", "вода", "гром" и т.д.
    let qualities: [String]? // Массив качеств: ["напряжение", "рост", "застой"]
    let trigrams: TrigramPair?
    let lineTexts: [String]? // Массив из 6 элементов (трактовка каждой линии)
    let reflectionQuestions: [String]? // Вопросы для размышления
    
    // Стратегические блоки
    let generalStrategy: String?
    let subordinateStrategy: String?
    let leadershipStrategy: String?
    let practicalAdvice: [String]?
    
    struct TrigramPair: Codable, Hashable {
        let upper: Trigram
        let lower: Trigram
    }
    
    static func loadAll() -> [Hexagram] {
        guard let url = Bundle.main.url(forResource: "hexagrams", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let hexagrams = try? JSONDecoder().decode([Hexagram].self, from: data) else {
            return []
        }
        return hexagrams
    }
    
    static func find(byLines lines: [Line]) -> Hexagram? {
        guard lines.count == 6 else {
            return nil
        }
        
        let hexagrams = loadAll()
        guard !hexagrams.isEmpty else {
            return nil
        }
        
        // Линии идут снизу вверх (position 1-6)
        // Для бинарного представления читаем снизу вверх (position 1 = младший бит)
        let sortedLines = lines.sorted { $0.position < $1.position }
        let binary = sortedLines.map { $0.isYang ? "1" : "0" }.joined()
        
        // Преобразуем бинарное число в десятичное
        guard let binaryNumber = Int(binary, radix: 2) else {
            return hexagrams.first // Fallback на первую гексаграмму
        }
        
        // Добавляем 1 для соответствия нумерации (гексаграммы 1-64)
        let number = binaryNumber + 1
        // Ограничиваем номер диапазоном 1-64
        let validNumber = min(max(number, 1), 64)
        return hexagrams.first { $0.number == validNumber } ?? hexagrams.first
    }
    
    // Вычисление второй гексаграммы из меняющихся линий
    static func findSecond(byLines lines: [Line]) -> Hexagram? {
        // Создаем новые линии, меняя меняющиеся линии на противоположные
        let changedLines = lines.map { line -> Line in
            if line.isChanging {
                return Line(isYang: !line.isYang, isChanging: false, position: line.position)
            } else {
                return line
            }
        }
        return find(byLines: changedLines)
    }
    
    // Поиск гексаграммы по номеру
    static func findByNumber(_ number: Int) -> Hexagram? {
        let hexagrams = loadAll()
        return hexagrams.first { $0.number == number }
    }
}

struct Line: Identifiable, Hashable {
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
    
    // Новые поля для базового дневника
    let summary: String?
    let userNotes: String?
    let secondHexagramNumber: Int?
    
    // Поля для расширенного дневника (Фаза 2)
    let tags: [String]?
    let outcome: String?
    
    struct LineData: Codable {
        let isYang: Bool
        let isChanging: Bool
        let position: Int
    }
    
    var uuid: UUID {
        UUID(uuidString: id) ?? UUID()
    }
    
    init(date: Date, question: String?, hexagram: Hexagram, lines: [Line], secondHexagram: Hexagram? = nil) {
        self.id = UUID().uuidString
        self.date = date
        self.question = question
        self.hexagramNumber = hexagram.number
        self.hexagramName = hexagram.name
        self.lines = lines.map { LineData(isYang: $0.isYang, isChanging: $0.isChanging, position: $0.position) }
        self.interpretation = hexagram.interpretation
        self.summary = hexagram.keyPhrase ?? hexagram.interpretation
        self.userNotes = nil
        self.secondHexagramNumber = secondHexagram?.number
        self.tags = nil
        self.outcome = nil
    }
    
    // Функция для создания обновленной версии
    func updated(userNotes: String? = nil, tags: [String]? = nil, outcome: String? = nil) -> Reading {
        Reading(
            id: self.id,
            date: self.date,
            question: self.question,
            hexagramNumber: self.hexagramNumber,
            hexagramName: self.hexagramName,
            lines: self.lines,
            interpretation: self.interpretation,
            summary: self.summary,
            userNotes: userNotes ?? self.userNotes,
            secondHexagramNumber: self.secondHexagramNumber,
            tags: tags ?? self.tags,
            outcome: outcome ?? self.outcome
        )
    }
    
    // Приватный инициализатор для обновления
    private init(
        id: String,
        date: Date,
        question: String?,
        hexagramNumber: Int,
        hexagramName: String,
        lines: [LineData],
        interpretation: String,
        summary: String?,
        userNotes: String?,
        secondHexagramNumber: Int?,
        tags: [String]?,
        outcome: String?
    ) {
        self.id = id
        self.date = date
        self.question = question
        self.hexagramNumber = hexagramNumber
        self.hexagramName = hexagramName
        self.lines = lines
        self.interpretation = interpretation
        self.summary = summary
        self.userNotes = userNotes
        self.secondHexagramNumber = secondHexagramNumber
        self.tags = tags
        self.outcome = outcome
    }
}

