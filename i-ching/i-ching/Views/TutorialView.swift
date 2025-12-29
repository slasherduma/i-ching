import SwiftUI

struct TutorialView: View {
    @State private var currentPage: Int = 0
    @Binding var isPresented: Bool
    
    private let pages: [TutorialPage] = [
        TutorialPage(
            title: "Что такое гексаграмма",
            content: "Гексаграмма состоит из шести линий, которые строятся снизу вверх. Каждая линия может быть сплошной (ян) или прерванной (инь).",
            visual: .hexagram
        ),
        TutorialPage(
            title: "Метод трёх монет",
            content: "Бросай три монеты шесть раз. Каждый бросок создаёт одну линию гексаграммы. Меняющиеся линии (6 и 9) показывают точки перемен.",
            visual: .coins
        ),
        TutorialPage(
            title: "Зачем нужен вопрос",
            content: "Хороший вопрос помогает сфокусировать размышление. Например: \"Как будет развиваться моя карьера?\" или \"Что для меня значит это решение?\"",
            visual: .question
        )
    ]
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Визуализация
                if currentPage < pages.count {
                    TutorialVisual(type: pages[currentPage].visual)
                        .frame(height: 200)
                        .padding(.bottom, 60)
                }
                
                // Контент
                if currentPage < pages.count {
                    VStack(spacing: 20) {
                        Text(pages[currentPage].title)
                            .font(.system(size: 20, weight: .light))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                        
                        Text(pages[currentPage].content)
                            .font(.system(size: 16, weight: .ultraLight))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 60)
                    }
                    .padding(.bottom, 80)
                }
                
                Spacer()
                
                // Навигация
                HStack(spacing: 30) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Text("Назад")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                        }
                    } else {
                        Spacer()
                    }
                    
                    // Индикаторы страниц
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Далее")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                        }
                    } else {
                        Button(action: {
                            markTutorialAsSeen()
                            isPresented = false
                        }) {
                            Text("Начать")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 60)
            }
        }
    }
    
    private func markTutorialAsSeen() {
        UserDefaults.standard.set(true, forKey: "hasSeenTutorial")
    }
}

struct TutorialPage {
    let title: String
    let content: String
    let visual: TutorialVisualType
}

enum TutorialVisualType {
    case hexagram
    case coins
    case question
}

struct TutorialVisual: View {
    let type: TutorialVisualType
    
    var body: some View {
        Group {
            switch type {
            case .hexagram:
                VStack(spacing: 8) {
                    ForEach(0..<6) { index in
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 120, height: 3)
                    }
                }
            case .coins:
                HStack(spacing: 20) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 60)
                    }
                }
            case .question:
                Text("?")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundColor(.gray)
            }
        }
    }
}

