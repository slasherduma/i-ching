import SwiftUI
import UIKit

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
        GeometryReader { geometry in
            ZStack {
                // Бежевый фон
                DesignConstants.TutorialScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Верхний отступ до визуализации
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.TutorialScreen.Spacing.topToVisual, for: geometry, isVertical: true))
                    
                    // Визуализация
                    if currentPage < pages.count {
                        TutorialVisual(type: pages[currentPage].visual, geometry: geometry)
                            .frame(height: scaledValue(DesignConstants.TutorialScreen.Spacing.visualHeight, for: geometry, isVertical: true))
                            .padding(.bottom, scaledValue(DesignConstants.TutorialScreen.Spacing.visualToTitle, for: geometry, isVertical: true))
                    }
                    
                    // Контент
                    if currentPage < pages.count {
                        VStack(spacing: 0) {
                            // Заголовок
                            Text(pages[currentPage].title)
                                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.titleSize, for: geometry)))
                                .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                                .padding(.bottom, scaledValue(DesignConstants.TutorialScreen.Spacing.titleToContent, for: geometry, isVertical: true))
                            
                            // Основной текст
                            Text(pages[currentPage].content)
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.bodySize, for: geometry)))
                                .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                        }
                        .padding(.bottom, scaledValue(DesignConstants.TutorialScreen.Spacing.contentToNavigation, for: geometry, isVertical: true))
                    }
                    
                    Spacer()
                }
                
                // Счетчик страниц по центру экрана
                VStack {
                    Spacer()
                    Text("\(currentPage + 1)/\(pages.count)")
                        .font(robotoMonoThinFont(size: scaledFontSize(22, for: geometry)))
                        .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                    Spacer()
                }
            }
            .overlay(alignment: .bottom) {
                // Use dual layout with conditional left button visibility
                if currentPage > 0 {
                    BottomBar.dual(
                        leftTitle: "НАЗАД",
                        leftAction: {
                            withAnimation {
                                currentPage -= 1
                            }
                        },
                        rightTitle: currentPage < pages.count - 1 ? "ДАЛЕЕ" : "ВЫХОД В МЕНЮ",
                        rightAction: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                markTutorialAsSeen()
                                isPresented = false
                            }
                        },
                        lift: DesignConstants.Layout.ctaLiftSticky,
                        geometry: geometry
                    )
                    .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
                } else {
                    // First page: only right button (ДАЛЕЕ)
                    BottomBar.primary(
                        title: "ДАЛЕЕ",
                        action: {
                            withAnimation {
                                currentPage += 1
                            }
                        },
                        lift: DesignConstants.Layout.ctaLiftSticky,
                        geometry: geometry
                    )
                    .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToStartView"))) { _ in
                // Закрываем экран при получении уведомления о возврате на стартовый экран
                // Используем transaction без анимации для мгновенного закрытия
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isPresented = false
                }
            }
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        // Проверяем, что свайп преимущественно горизонтальный
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            if horizontalAmount < 0 {
                                // Свайп влево - следующая страница
                                if currentPage < pages.count - 1 {
                                    withAnimation {
                                        currentPage += 1
                                    }
                                }
                            } else {
                                // Свайп вправо - предыдущая страница
                                if currentPage > 0 {
                                    withAnimation {
                                        currentPage -= 1
                                    }
                                }
                            }
                        }
                    }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Roboto Mono Thin для заголовков
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "Roboto Mono Thin",
            "RobotoMono-Thin",
            "RobotoMonoThin",
            "RobotoMono-VariableFont_wght"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
    /// Создает шрифт Helvetica Neue Light для основного текста
    private func helveticaNeueLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Helvetica Neue Light",
            "HelveticaNeue-Light",
            "HelveticaNeueLight",
            "Helvetica Neue",
            "HelveticaNeue"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .light)
    }
    
    /// Создает шрифт Druk Wide Cyr Medium для кнопок
    private func drukWideCyrMediumFont(size: CGFloat) -> Font {
        let fontNames = [
            "Druk Wide Cyr Medium",
            "DrukWideCyr-Medium",
            "DrukWideCyrMedium",
            "Druk Wide Cyr Medium Regular",
            "DrukWideCyrMedium-Regular",
            "Druk Wide Cyr",
            "DrukWideCyr",
            "Druk Wide Cyr Regular",
            "DrukWideCyr-Regular"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .medium)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.TutorialScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.TutorialScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Создает шрифт Roboto Mono Light
    private func robotoMonoLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Roboto Mono Light",
            "RobotoMono-Light",
            "RobotoMonoLight",
            "RobotoMono-VariableFont_wght",
            "Roboto Mono",
            "RobotoMono"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .light, design: .monospaced)
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует минимальный коэффициент для сохранения пропорций макета
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        // Если размер относится к CoinsScreen (кнопки), используем его базовые размеры
        let widthScaleFactor: CGFloat
        let heightScaleFactor: CGFloat
        
        if size == DesignConstants.CoinsScreen.Typography.buttonTextSize {
            widthScaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            widthScaleFactor = geometry.size.width / DesignConstants.TutorialScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.TutorialScreen.baseScreenHeight
        }
        
        // Используем минимальный коэффициент для сохранения пропорций
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
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
    let geometry: GeometryProxy
    
    // Пример гексаграммы для туториала (гексаграмма 11 - МИР)
    // Линии снизу вверх: ян, ян, ян, инь, ян, ян
    private let exampleLines: [Line] = [
        Line(isYang: true, isChanging: false, position: 1),
        Line(isYang: true, isChanging: false, position: 2),
        Line(isYang: true, isChanging: false, position: 3),
        Line(isYang: false, isChanging: false, position: 4),
        Line(isYang: true, isChanging: false, position: 5),
        Line(isYang: true, isChanging: false, position: 6)
    ]
    
    var body: some View {
        Group {
            switch type {
            case .hexagram:
                VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                    ForEach(Array(exampleLines.reversed()), id: \.id) { line in
                        LineView(line: line, geometry: geometry)
                    }
                }
            case .coins:
                HStack(spacing: scaledValue(DesignConstants.CoinsScreen.Spacing.betweenCircles, for: geometry)) {
                    // Три монеты для примера: орел, решка, орел
                    CoinView(isHeads: true, isThrowing: false, geometry: geometry)
                    CoinView(isHeads: false, isThrowing: false, geometry: geometry)
                    CoinView(isHeads: true, isThrowing: false, geometry: geometry)
                }
            case .question:
                Text("?")
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue.opacity(0.5))
            }
        }
    }
    
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
}
