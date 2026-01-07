import SwiftUI
import Combine

/// Enum для представления всех экранов в приложении
enum Screen: Hashable {
    case question
    case coins(question: String?)
    case hexagram(hexagram: Hexagram, lines: [Line], question: String?)
    case interpretation(hexagram: Hexagram, lines: [Line], question: String?, secondHexagram: Hexagram?)
    case result(hexagram: Hexagram, lines: [Line], question: String?)
    
    /// Создает соответствующий View для экрана
    @ViewBuilder
    var view: some View {
        switch self {
        case .question:
            QuestionView()
        case .coins(let question):
            CoinsView(question: question)
        case .hexagram(let hexagram, let lines, let question):
            HexagramView(hexagram: hexagram, lines: lines, question: question)
        case .interpretation(let hexagram, let lines, let question, let secondHexagram):
            InterpretationView(hexagram: hexagram, lines: lines, question: question, secondHexagram: secondHexagram)
        case .result(let hexagram, let lines, let question):
            ResultView(hexagram: hexagram, lines: lines, question: question)
        }
    }
}

/// Менеджер навигации для управления стеком экранов
class NavigationManager: ObservableObject {
    @Published var screens: [Screen] = []
    
    /// Текущий экран (последний в стеке)
    var currentScreen: Screen? {
        screens.last
    }
    
    /// Переход на указанный экран
    func navigate(to screen: Screen) {
        withAnimation(.easeInOut(duration: 0.2)) {
            screens.append(screen)
        }
    }
    
    /// Возврат к корневому экрану (StartView)
    func popToRoot() {
        withAnimation(.easeInOut(duration: 0.2)) {
            screens.removeAll()
        }
    }
    
    /// Возврат на один экран назад
    func pop() {
        if !screens.isEmpty {
            withAnimation(.easeInOut(duration: 0.2)) {
                screens.removeLast()
            }
        }
    }
}

