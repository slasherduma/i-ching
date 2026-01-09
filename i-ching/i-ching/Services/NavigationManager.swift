import SwiftUI
import Combine

/// Enum для представления всех экранов в приложении
enum Screen: Hashable {
    case question
    case coins(question: String?)
    case hexagram(hexagram: Hexagram, lines: [Line], question: String?)
    case interpretation(hexagram: Hexagram, lines: [Line], question: String?, secondHexagram: Hexagram?)
    case result(hexagram: Hexagram, lines: [Line], question: String?)
    case dailySign
    case history
    case tutorial
    
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
        case .dailySign:
            DailySignView(resetForTesting: false)
        case .history:
            HistoryView()
        case .tutorial:
            TutorialViewWrapper()
        }
    }
}

/// Менеджер навигации для управления стеком экранов
class NavigationManager: ObservableObject {
    @Published var screens: [Screen] = []
    @Published var currentHexagramLines: [Line] = [] // Линии текущей гексограммы для overlay
    
    /// Текущий экран (последний в стеке)
    var currentScreen: Screen? {
        screens.last
    }
    
    /// Обновляет линии гексограммы для overlay
    func updateHexagramLines(_ lines: [Line]) {
        currentHexagramLines = lines
    }
    
    /// Переход на указанный экран
    func navigate(to screen: Screen) {
        screens.append(screen)
    }
    
    /// Возврат к корневому экрану (StartView)
    func popToRoot() {
        screens.removeAll()
        currentHexagramLines = [] // Очищаем гексограмму при возврате на StartView
    }
    
    /// Возврат на один экран назад
    func pop() {
        if !screens.isEmpty {
            screens.removeLast()
        }
    }
}

/// Wrapper для TutorialView, который работает через NavigationManager
struct TutorialViewWrapper: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isPresented = true
    
    var body: some View {
        TutorialView(isPresented: Binding(
            get: { isPresented },
            set: { newValue in
                isPresented = newValue
                if !newValue {
                    // Используем небольшое задержку, чтобы дать TutorialView завершить свою анимацию
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        navigationManager.popToRoot()
                    }
                }
            }
        ))
        .environmentObject(navigationManager)
    }
}

