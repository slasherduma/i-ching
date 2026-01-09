import SwiftUI
import UIKit

enum TutorialEntryPoint: Hashable {
    case firstLaunch
    case fromMenu
}

struct TutorialView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var musicService: BackgroundMusicService
    @AppStorage("hasSeenTutorial") private var hasSeenTutorial: Bool = false
    @State private var currentPage: Int = 0
    @Binding var isPresented: Bool
    let entryPoint: TutorialEntryPoint
    
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
                
                ZStack(alignment: .top) {
                    // Визуализация и заголовок - разные для каждой страницы
                    VStack(spacing: 0) {
                        if currentPage < pages.count {
                            if pages[currentPage].visual == .hexagram {
                                // Страница 1: гексаграмма
                                let titleTop = scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram - 80, for: geometry, isVertical: true)
                                
                                Spacer()
                                    .frame(height: titleTop)
                                
                                // Заголовок
                                Text(pages[currentPage].title)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.titleSize, for: geometry)))
                                    .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                                
                                // Отступ от заголовка до гексаграммы: 80px
                                Spacer()
                                    .frame(height: scaledValue(80, for: geometry, isVertical: true))
                                
                                // Гексаграмма
                                TutorialVisual(type: .hexagram, geometry: geometry)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                            } else if pages[currentPage].visual == .coins {
                                // Страница 2: монеты
                                let titleTop = scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram - 80, for: geometry, isVertical: true)
                                
                                Spacer()
                                    .frame(height: titleTop)
                                
                                // Заголовок
                                Text(pages[currentPage].title)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.titleSize, for: geometry)))
                                    .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                                
                                // Отступ от заголовка до монет: 80px
                                Spacer()
                                    .frame(height: scaledValue(80, for: geometry, isVertical: true))
                                
                                // Монеты
                                TutorialVisual(type: .coins, geometry: geometry)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                            } else {
                                // Страница 3: знак вопроса - заголовок сверху, знак вопроса под ним (как на странице 2)
                                let titleTop = scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram - 80, for: geometry, isVertical: true)
                                
                                Spacer()
                                    .frame(height: titleTop)
                                
                                // Заголовок
                                Text(pages[currentPage].title)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.titleSize, for: geometry)))
                                    .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                                
                                // Отступ от заголовка до знака вопроса: 80px
                                Spacer()
                                    .frame(height: scaledValue(80, for: geometry, isVertical: true))
                                
                                // Знак вопроса на той же позиции, что и монеты на странице 2 (topToHexagram = 360px)
                                TutorialVisual(type: .question, geometry: geometry)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Основной текст - всегда на фиксированной позиции 610px от верха
                    // Используем одинаковые параметры форматирования для всех страниц
                    if currentPage < pages.count {
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: scaledValue(610, for: geometry, isVertical: true))
                            
                            Text(pages[currentPage].content)
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.TutorialScreen.Typography.bodySize, for: geometry)))
                                .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, scaledValue(DesignConstants.TutorialScreen.Spacing.horizontalPadding, for: geometry))
                                .padding(.bottom, scaledValue(DesignConstants.TutorialScreen.Spacing.contentToNavigation, for: geometry, isVertical: true))
                            
                            Spacer()
                        }
                    }
                }
                .frame(width: geometry.size.width, alignment: .center)
            }
            .overlay(alignment: .top) {
                if entryPoint == .firstLaunch {
                    StartMenuBarView(geometry: geometry, customCenterText: "ТУТОРИАЛ")
                        .environmentObject(musicService)
                } else {
                    MenuBarView(geometry: geometry, onDismiss: { isPresented = false })
                        .environmentObject(navigationManager)
                }
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Счетчик страниц над кнопками с отступом 320px
                    VStack(spacing: scaledValue(8, for: geometry, isVertical: true)) {
                        Text("\(currentPage + 1)/\(pages.count)")
                            .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                            .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                            .frame(maxWidth: .infinity)
                        
                        // Индикатор страниц - 3 точки
                        HStack(spacing: scaledValue(8, for: geometry)) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? DesignConstants.TutorialScreen.Colors.textBlue : Color.clear)
                                    .frame(width: scaledValue(8, for: geometry), height: scaledValue(8, for: geometry))
                                    .overlay(
                                        Circle()
                                            .stroke(DesignConstants.TutorialScreen.Colors.textBlue, lineWidth: scaledValue(1, for: geometry))
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, scaledValue(320, for: geometry, isVertical: true))
                    
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
                    // First page: dual bottom bar - левая "ВЫХОД В МЕНЮ", правая "ДАЛЕЕ"
                    BottomBar.dual(
                        leftTitle: "ВЫХОД В МЕНЮ",
                        leftAction: {
                            markTutorialAsSeen()
                            isPresented = false
                        },
                        rightTitle: "ДАЛЕЕ",
                        rightAction: {
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
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToStartView"))) { _ in
                // Закрываем экран при получении уведомления о возврате на стартовый экран
                // Используем стандартную анимацию cross fade через NavigationManager
                markTutorialAsSeen()
                isPresented = false
            }
            .gesture(
                DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        // Проверяем, что свайп преимущественно горизонтальный
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            // Свайп слева направо от левого края - возврат в главное меню
                            if value.startLocation.x < 50 && horizontalAmount > 100 {
                                markTutorialAsSeen()
                                isPresented = false
                            } else if horizontalAmount < -50 {
                                // Свайп влево - следующая страница
                                if currentPage < pages.count - 1 {
                                    withAnimation {
                                        currentPage += 1
                                    }
                                }
                            } else if horizontalAmount > 50 {
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
    /// Если значение относится к CoinsScreen (гексаграмма), использует его базовые размеры
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        // Если значение относится к CoinsScreen (гексаграмма), используем его базовые размеры
        if value == DesignConstants.CoinsScreen.Spacing.topToHexagram ||
           value == DesignConstants.CoinsScreen.Sizes.lineSpacing ||
           value == DesignConstants.CoinsScreen.Sizes.lineThickness {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            }
        } else {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.TutorialScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.TutorialScreen.baseScreenWidth
            }
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
        hasSeenTutorial = true
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
                .frame(maxWidth: .infinity, alignment: .center)
            case .coins:
                HStack(spacing: scaledValue(DesignConstants.CoinsScreen.Spacing.betweenCircles, for: geometry)) {
                    // Три монеты для примера: орел, решка, орел
                    CoinView(isHeads: true, isThrowing: false, geometry: geometry)
                    CoinView(isHeads: false, isThrowing: false, geometry: geometry)
                    CoinView(isHeads: true, isThrowing: false, geometry: geometry)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            case .question:
                Image("question_mark")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(DesignConstants.TutorialScreen.Colors.textBlue)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: scaledValue(150, for: geometry, isVertical: true))
                    .frame(maxWidth: .infinity, alignment: .center)
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
