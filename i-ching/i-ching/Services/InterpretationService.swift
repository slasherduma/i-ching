import Foundation

enum MoodLevel: String, Codable {
    case cautious = "осторожно"
    case balanced = "уравновешенно"
    case opportunities = "много шансов"
}

enum AnchorIcon: String, Codable {
    case wave = "волна"
    case mountain = "гора"
    case lightning = "молния"
    case sun = "солнце"
}

struct InterpretationResult {
    let now: [String]        // 3–5 предложений
    let changes: [String]    // 1–3 пункта
    let trend: [String]?     // 2–4, если есть 2-я гекс.
    let practical: [String]  // 2–3 действия
    let mood: MoodLevel
    let anchors: [AnchorIcon]
    let safetyCheck: SafetyCheck
}

class InterpretationService {
    static let shared = InterpretationService()
    
    private init() {}
    
    func generateInterpretation(
        hexagram: Hexagram,
        lines: [Line],
        question: String?,
        secondHexagram: Hexagram?
    ) -> InterpretationResult {
        let safetyCheck = SafetyService.shared.checkQuestion(question)
        
        // Блок "Сейчас"
        let now = generateNowBlock(hexagram: hexagram)
        
        // Блок "Что будет меняться"
        let changes = generateChangesBlock(lines: lines, hexagram: hexagram)
        
        // Блок "Тенденция"
        let trend = secondHexagram != nil ? generateTrendBlock(secondHexagram: secondHexagram!) : nil
        
        // Блок "Практическая подсказка"
        let practical = generatePracticalBlock(hexagram: hexagram)
        
        // Настроение и якоря
        let mood = determineMood(hexagram: hexagram)
        let anchors = determineAnchors(hexagram: hexagram)
        
        return InterpretationResult(
            now: now,
            changes: changes,
            trend: trend,
            practical: practical,
            mood: mood,
            anchors: anchors,
            safetyCheck: safetyCheck
        )
    }
    
    private func generateNowBlock(hexagram: Hexagram) -> [String] {
        var sentences: [String] = []
        
        // Используем generalStrategy как основу для блока "Сейчас"
        if let generalStrategy = hexagram.generalStrategy {
            // Разбиваем generalStrategy на предложения по точкам
            let parts = generalStrategy.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            sentences.append(contentsOf: parts.prefix(3).map { $0 + "." })
        } else if let keyPhrase = hexagram.keyPhrase {
            sentences.append(keyPhrase)
        } else {
            sentences.append(hexagram.interpretation)
        }
        
        // Если мало предложений, добавляем интерпретацию
        if sentences.isEmpty {
            sentences.append(hexagram.interpretation)
        }
        
        // Ограничиваем до 5 предложений
        return Array(sentences.prefix(5))
    }
    
    private func generateChangesBlock(lines: [Line], hexagram: Hexagram) -> [String] {
        let changingLines = lines.filter { $0.isChanging }
        
        guard !changingLines.isEmpty else {
            return ["Ситуация стабильна, значительных изменений не предвидится."]
        }
        
        var changes: [String] = []
        
        // Используем тексты линий, если доступны
        if let lineTexts = hexagram.lineTexts {
            for changingLine in changingLines {
                let position = changingLine.position - 1
                if position >= 0 && position < lineTexts.count {
                    let lineText = lineTexts[position]
                    changes.append("В ближайшее время возможен такой поворот: \(lineText)")
                }
            }
        } else {
            // Генерируем общий текст о меняющихся линиях
            changes.append("В ближайшее время возможны изменения в \(changingLines.count) аспектах ситуации.")
            if changingLines.count > 1 {
                changes.append("Если ты продолжишь как сейчас, эти изменения могут повлиять на развитие событий.")
            }
        }
        
        return Array(changes.prefix(3))
    }
    
    private func generateTrendBlock(secondHexagram: Hexagram) -> [String] {
        var trend: [String] = []
        
        if let keyPhrase = secondHexagram.keyPhrase {
            trend.append(keyPhrase)
        } else {
            trend.append(secondHexagram.interpretation)
        }
        
        if let qualities = secondHexagram.qualities, !qualities.isEmpty {
            trend.append("Это приведет к проявлению качеств: \(qualities.joined(separator: ", ")).")
        }
        
        trend.append("Важно учитывать это направление при принятии решений.")
        
        return Array(trend.prefix(4))
    }
    
    private func generatePracticalBlock(hexagram: Hexagram) -> [String] {
        // Используем practicalAdvice из данных, если есть
        if let practicalAdvice = hexagram.practicalAdvice, !practicalAdvice.isEmpty {
            return practicalAdvice
        }
        
        // Fallback: базовые советы на основе интерпретации
        var practical: [String] = []
        let interpretation = hexagram.interpretation.lowercased()
        
        if interpretation.contains("терпение") || interpretation.contains("ждать") {
            practical.append("Не торопи события.")
        }
        
        if interpretation.contains("осторожн") || interpretation.contains("опасн") {
            practical.append("Действуй осторожно и обдуманно.")
        }
        
        if interpretation.contains("активн") || interpretation.contains("действ") {
            practical.append("Время для решительных действий.")
        }
        
        if interpretation.contains("гармони") || interpretation.contains("сотрудничеств") {
            practical.append("Согласуй ожидания с партнерами.")
        }
        
        // Если не набрали достаточно советов, добавляем общий
        if practical.isEmpty {
            practical.append("Прислушивайся к внутреннему голосу.")
        }
        
        return Array(practical.prefix(3))
    }
    
    private func determineMood(hexagram: Hexagram) -> MoodLevel {
        let interpretation = hexagram.interpretation.lowercased()
        
        if interpretation.contains("опасн") || interpretation.contains("трудн") || interpretation.contains("препятстви") {
            return .cautious
        }
        
        if interpretation.contains("успех") || interpretation.contains("благоприятн") || interpretation.contains("изобилие") {
            return .opportunities
        }
        
        return .balanced
    }
    
    private func determineAnchors(hexagram: Hexagram) -> [AnchorIcon] {
        var anchors: [AnchorIcon] = []
        
        if let image = hexagram.image {
            let imageLower = image.lowercased()
            if imageLower.contains("вода") || imageLower.contains("море") {
                anchors.append(.wave)
            }
            if imageLower.contains("гора") {
                anchors.append(.mountain)
            }
            if imageLower.contains("гром") || imageLower.contains("молния") {
                anchors.append(.lightning)
            }
            if imageLower.contains("небо") || imageLower.contains("солнце") || imageLower.contains("огонь") {
                anchors.append(.sun)
            }
        }
        
        // Если не нашли по образу, определяем по качествам
        if anchors.isEmpty, let qualities = hexagram.qualities {
            for quality in qualities {
                let qualityLower = quality.lowercased()
                if qualityLower.contains("движен") || qualityLower.contains("активн") {
                    anchors.append(.wave)
                }
                if qualityLower.contains("стабильн") || qualityLower.contains("покой") {
                    anchors.append(.mountain)
                }
            }
        }
        
        // Если все еще пусто, добавляем по умолчанию
        if anchors.isEmpty {
            anchors.append(.sun)
        }
        
        return Array(anchors.prefix(2))
    }
}

