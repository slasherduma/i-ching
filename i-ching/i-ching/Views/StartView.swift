import SwiftUI
import UIKit

struct StartView: View {
    @State private var showQuestion = false
    @State private var showHistory = false
    @State private var showTutorial = false
    @State private var showDailySign = false
    
    private var hasSeenTutorial: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenTutorial")
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Бежевый фон
                DesignConstants.StartScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Верхний отступ до иероглифов (вертикальный отступ - используем высоту)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.topToChineseCharacters, for: geometry, isVertical: true))
                    
                    // Иероглифы 乾 и 坤 сверху
                    HStack(spacing: scaledValue(DesignConstants.StartScreen.Spacing.betweenChineseCharacters, for: geometry)) {
                        Text("乾")
                            .font(zenOldMinchoFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.chineseCharactersSize, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                        
                        Text("坤")
                            .font(zenOldMinchoFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.chineseCharactersSize, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                    }
                    .padding(.horizontal, scaledValue(DesignConstants.StartScreen.Spacing.chineseCharactersHorizontalPadding, for: geometry))
                    .frame(maxWidth: .infinity)
                    
                    // Отступ от иероглифов до драконов (12px из макета - вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.chineseCharactersToDragons, for: geometry, isVertical: true))
                    
                    // Драконы - центрируем по горизонтали и вертикали
                    // Используем ширину для горизонтального масштабирования, высоту для вертикального
                    let horizontalScaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
                    let verticalScaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
                    let dragonsWidth = DesignConstants.StartScreen.Spacing.dragonsWidth * horizontalScaleFactor
                    let dragonsHeight = DesignConstants.StartScreen.Spacing.dragonsHeight * verticalScaleFactor
                    
                    HStack {
                        Spacer()
                        Group {
                            if let uiImage = UIImage(named: "dragons-hero") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: dragonsWidth, height: dragonsHeight)
                                    .clipped()
                            } else if let url = Bundle.main.url(forResource: "dragons-hero", withExtension: "svg"),
                                      let image = UIImage(contentsOfFile: url.path) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: dragonsWidth, height: dragonsHeight)
                                    .clipped()
                            } else {
                                // Заглушка для отладки
                                Rectangle()
                                    .fill(Color.red.opacity(0.2))
                                    .frame(width: dragonsWidth, height: dragonsHeight)
                                    .overlay(
                                        VStack {
                                            Text("dragons-hero не найден")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                            Text("Добавьте в Assets.xcassets")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                        Spacer()
                    }
                    
                    // Отступ от драконов до первой кнопки (190px из макета - вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.dragonsToFirstButton, for: geometry, isVertical: true))
                    
                    // Кнопки
                    VStack(spacing: scaledValue(DesignConstants.StartScreen.Spacing.buttonSpacing, for: geometry, isVertical: true)) {
                        Button(action: {
                            showQuestion = true
                        }) {
                            Text("СДЕЛАТЬ РАСКЛАД")
                                .font(drukWideCyrFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonBlue)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            showDailySign = true
                        }) {
                            Text("ЗНАК ДНЯ")
                                .font(drukWideCyrFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonBlue)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            showHistory = true
                        }) {
                            Text("ДНЕВНИК ПРЕДСКАЗАНИЙ")
                                .font(drukWideCyrFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonBlue)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Нижний отступ (вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.lastButtonToBottom, for: geometry, isVertical: true))
                }
                
                // Тексты "И-ЦЗИН" и "КНИГА ПЕРЕМЕН" позиционируются относительно нижнего края
                VStack(spacing: 0) {
                    Spacer()
                    
                    // "И-ЦЗИН" на 476px от нижнего края (с учетом масштабирования)
                    Text("И-ЦЗИН")
                        .font(drukXXCondensedFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.mainTitleSize, for: geometry)))
                        .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                        .lineLimit(1)
                    
                    // "КНИГА ПЕРЕМЕН" на 20px ниже "И-ЦЗИН" (с учетом масштабирования - вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.subtitleFromMainTitle, for: geometry, isVertical: true))
                    
                    Text("КНИГА ПЕРЕМЕН")
                        .font(helveticaNeueFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.subtitleSize, for: geometry)))
                        .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                        .lineLimit(1)
                    
                    // Отступ от нижнего края до "И-ЦЗИН" = 476px (с учетом масштабирования - вертикальный)
                    // Это расстояние от нижнего края до нижней границы "И-ЦЗИН"
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.mainTitleFromBottom, for: geometry, isVertical: true))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            // Показываем туториал при первом запуске
            if !hasSeenTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showTutorial = true
                }
            }
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView(isPresented: $showTutorial)
                .transition(.opacity)
        }
        .fullScreenCover(isPresented: $showQuestion) {
            QuestionView()
                .transition(.opacity)
        }
        .fullScreenCover(isPresented: $showDailySign) {
            DailySignView()
                .transition(.opacity)
        }
        .fullScreenCover(isPresented: $showHistory) {
            HistoryView()
                .transition(.opacity)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Zen Old Mincho для иероглифов
    private func zenOldMinchoFont(size: CGFloat) -> Font {
        // Проверяем все возможные варианты имен
        let fontNames = [
            "ZenOldMincho-Bold",
            "ZenOldMinchoBold",
            "Zen Old Mincho Bold",
            "ZenOldMincho",
            "Zen Old Mincho",
            "ZenOldMincho-Regular",
            "ZenOldMinchoRegular"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .bold)
    }
    
    /// Создает шрифт Druk XXCondensed Cyr Super для названия
    private func drukXXCondensedFont(size: CGFloat) -> Font {
        let fontNames = [
            "Druk XXCondensed Cyr Super",
            "DrukXXCondensedCyr-Super",
            "DrukXXCondensedCyrSuper",
            "Druk XXCondensed Cyr Super Regular",
            "DrukXXCondensedCyrSuper-Regular",
            "Druk XXCondensed Cyr",
            "DrukXXCondensedCyr"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .regular)
    }
    
    /// Создает шрифт Helvetica Neue для подзаголовка
    private func helveticaNeueFont(size: CGFloat) -> Font {
        let fontNames = [
            "Helvetica Neue",
            "HelveticaNeue",
            "HelveticaNeue-Regular"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .regular)
    }
    
    /// Создает шрифт Druk Wide Cyr для кнопок
    private func drukWideCyrFont(size: CGFloat) -> Font {
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .medium)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            // Для вертикальных отступов используем высоту с учетом safe zone
            // geometry.size уже учитывает safe area в GeometryReader
            scaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
        } else {
            // Для горизонтальных отступов используем ширину
            scaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта относительно базового размера экрана
    /// Используется более консервативное масштабирование для крупных шрифтов
    private func scaledSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let scaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
        // Для больших шрифтов применяем более консервативное масштабирование
        if size > 50 {
            let clampedScale = max(0.7, min(1.0, scaleFactor))
            return size * clampedScale
        }
        return size * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// В Figma макет 660×1434 @1x, используем минимальный коэффициент для сохранения пропорций
    /// Это гарантирует, что шрифты не будут слишком большими на узких экранах
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        // Вычисляем коэффициенты масштабирования по ширине и высоте
        let widthScaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
        
        // Используем минимальный коэффициент для сохранения пропорций макета
        // Это гарантирует, что шрифты будут соответствовать пропорциям исходного макета
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        
        return size * scaleFactor
    }
}
