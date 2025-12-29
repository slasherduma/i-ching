import Foundation

enum SafetyLevel {
    case normal
    case health
    case legal
    case danger
}

struct SafetyCheck {
    let level: SafetyLevel
    let disclaimer: String
    let recommendation: String?
}

class SafetyService {
    static let shared = SafetyService()
    
    private init() {}
    
    // Ключевые слова для определения типа вопроса
    private let healthKeywords = [
        "здоровье", "болезнь", "лечение", "врач", "медицин", "симптом", "диагноз",
        "лекарство", "терапия", "операция", "боль", "больной", "выздоровление"
    ]
    
    private let legalKeywords = [
        "юридическ", "закон", "суд", "адвокат", "право", "договор", "иск",
        "преступление", "ответственность", "законность", "нарушение"
    ]
    
    private let dangerKeywords = [
        "опасность", "риск", "угроза", "безопасность", "травма", "смерть",
        "критическ", "экстренн", "неотложн"
    ]
    
    func checkQuestion(_ question: String?) -> SafetyCheck {
        guard let question = question?.lowercased() else {
            return SafetyCheck(
                level: .normal,
                disclaimer: "Это инструмент размышления, не инструкция.",
                recommendation: nil
            )
        }
        
        // Проверка на опасность
        if dangerKeywords.contains(where: { question.contains($0) }) {
            return SafetyCheck(
                level: .danger,
                disclaimer: "Это инструмент размышления, не инструкция. В ситуациях, связанных с опасностью, важно обратиться к специалистам.",
                recommendation: "Если ситуация требует немедленных действий, обратитесь к соответствующим службам или специалистам."
            )
        }
        
        // Проверка на здоровье
        if healthKeywords.contains(where: { question.contains($0) }) {
            return SafetyCheck(
                level: .health,
                disclaimer: "Это инструмент размышления, не инструкция. В вопросах здоровья важно консультироваться с медицинскими специалистами.",
                recommendation: "Для вопросов о здоровье рекомендуется обратиться к врачу или другому квалифицированному медицинскому специалисту."
            )
        }
        
        // Проверка на юридические вопросы
        if legalKeywords.contains(where: { question.contains($0) }) {
            return SafetyCheck(
                level: .legal,
                disclaimer: "Это инструмент размышления, не инструкция. В юридических вопросах важно консультироваться с квалифицированными специалистами.",
                recommendation: "Для юридических вопросов рекомендуется обратиться к адвокату или другому квалифицированному юридическому специалисту."
            )
        }
        
        // Обычный вопрос
        return SafetyCheck(
            level: .normal,
            disclaimer: "Это инструмент размышления, не инструкция.",
            recommendation: nil
        )
    }
    
    func shouldShowRecommendation(for level: SafetyLevel) -> Bool {
        return level != .normal
    }
}

