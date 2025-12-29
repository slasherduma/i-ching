import SwiftUI

enum QuestionQuality {
    case tooGeneral
    case clear
    case tooSpecific
}

struct QuestionQualityIndicator: View {
    let quality: QuestionQuality?
    
    var body: some View {
        if let quality = quality {
            VStack(spacing: 8) {
                Text("Подсказка для ясности")
                    .font(.system(size: DesignConstants.Typography.infoSize, weight: DesignConstants.Typography.infoWeight))
                    .foregroundColor(DesignConstants.Colors.info)
                
                Text(qualityText(for: quality))
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
        } else {
            Text("Формулировка не влияет на ответ.\nВажно лишь удерживать вопрос в сознании\nво время броска монет.")
                .font(.system(size: DesignConstants.Typography.infoSize, weight: DesignConstants.Typography.infoWeight))
                .foregroundColor(DesignConstants.Colors.info)
                .multilineTextAlignment(.center)
                .lineSpacing(DesignConstants.Typography.infoLineSpacing)
                .padding(.top, 20)
        }
    }
    
    private func qualityText(for quality: QuestionQuality) -> String {
        switch quality {
        case .tooGeneral:
            return "слишком общий"
        case .clear:
            return "ясный"
        case .tooSpecific:
            return "слишком узкий"
        }
    }
    
    static func evaluate(_ question: String) -> QuestionQuality? {
        guard !question.isEmpty else { return nil }
        
        let trimmed = question.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let hasQuestionMark = trimmed.contains("?") || trimmed.contains("？")
        let hasQuestionWords = ["как", "что", "когда", "где", "почему", "зачем", "кто"].contains { trimmed.lowercased().hasPrefix($0) }
        
        // Слишком общий: меньше 3 слов или нет вопросительных слов
        if words.count < 3 || (!hasQuestionMark && !hasQuestionWords) {
            return .tooGeneral
        }
        
        // Слишком узкий: больше 20 слов
        if words.count > 20 {
            return .tooSpecific
        }
        
        // Ясный: от 3 до 20 слов с вопросительными словами
        return .clear
    }
}

