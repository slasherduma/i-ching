import SwiftUI
import UIKit

struct StartView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var tappedButtonId: String? = nil
    
    private var hasSeenTutorial: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenTutorial")
    }
    
    // Computed properties для цветов кнопок
    private var questionButtonColor: Color {
        tappedButtonId == "question" ? DesignConstants.StartScreen.Colors.titleRed : DesignConstants.StartScreen.Colors.buttonBlue
    }
    
    private var dailySignButtonColor: Color {
        tappedButtonId == "dailySign" ? DesignConstants.StartScreen.Colors.titleRed : DesignConstants.StartScreen.Colors.buttonBlue
    }
    
    private var historyButtonColor: Color {
        tappedButtonId == "history" ? DesignConstants.StartScreen.Colors.titleRed : DesignConstants.StartScreen.Colors.buttonBlue
    }
    
    private var tutorialButtonColor: Color {
        tappedButtonId == "tutorial" ? DesignConstants.StartScreen.Colors.titleRed : DesignConstants.StartScreen.Colors.buttonBlue
    }
    
    // Функция для обработки нажатия кнопки
    private func handleButtonTap(buttonId: String, action: @escaping () -> Void) {
        // Сначала показываем красный цвет
        tappedButtonId = buttonId
        
        // Задерживаем переход на экран, чтобы показать красный блинк
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            action()
            // Возвращаем цвет обратно через еще 0.1 секунду
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tappedButtonId = nil
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                    // Верхний отступ до иероглифов (вертикальный отступ - используем высоту)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.topToChineseCharacters, for: geometry, isVertical: true))
                    
                    // Иероглифы 乾 и 坤 сверху с надписью И-ЦЗИН между ними и КНИГА ПЕРЕМЕН под ней
                    HStack(spacing: 0) {
                        Text("乾")
                            .font(rampartOneFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.chineseCharactersSize, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                        
                        // Отступ 20px от иероглифа до "И-ЦЗИН"
                        Spacer()
                            .frame(width: scaledValue(20, for: geometry))
                        
                        // VStack для "И-ЦЗИН" и "КНИГА ПЕРЕМЕН" - используем overlay для точного позиционирования
                        ZStack(alignment: .top) {
                            Text("И-ЦЗИН")
                                .font(drukXXCondensedFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.mainTitleSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                                .lineLimit(1)
                            
                            Text("КНИГА ПЕРЕМЕН")
                                .font(drukXXCondensedFont(size: scaledFontSize(42, for: geometry))) // Увеличено для соответствия отступам "И-ЦЗИН"
                                .tracking(scaledFontSize(42, for: geometry) * 0.07) // Увеличение расстояния между буквами на 7%
                                .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                                .lineLimit(1)
                                .offset(y: scaledFontSize(DesignConstants.StartScreen.Typography.mainTitleSize, for: geometry) + scaledValue(2.5, for: geometry, isVertical: true))
                        }
                        
                        // Отступ 20px от "И-ЦЗИН" до иероглифа
                        Spacer()
                            .frame(width: scaledValue(20, for: geometry))
                        
                        Text("坤")
                            .font(rampartOneFont(size: scaledFontSize(DesignConstants.StartScreen.Typography.chineseCharactersSize, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.titleRed)
                    }
                    .padding(.horizontal, scaledValue(DesignConstants.StartScreen.Spacing.chineseCharactersHorizontalPadding, for: geometry))
                    .frame(maxWidth: .infinity)
                    
                    // Минимальный отступ от "КНИГА ПЕРЕМЕН" до драконов
                    // Убираем большой отступ, чтобы поднять драконы
                    Spacer()
                        .frame(height: scaledValue(10, for: geometry, isVertical: true))
                    
                    // Драконы - центрируем по горизонтали с отступами 80px слева и справа
                    // При размере холста 660px ширина драконов = 660 - 160 (80*2) = 500px
                    let horizontalScaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
                    let verticalScaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
                    let dragonsWidth = (DesignConstants.StartScreen.baseScreenWidth - 160) * horizontalScaleFactor // 660 - 160 = 500px
                    let dragonsHeight = DesignConstants.StartScreen.Spacing.dragonsHeight * verticalScaleFactor
                    
                    HStack {
                        // Отступ слева 80px
                        Spacer()
                            .frame(width: scaledValue(80, for: geometry))
                        
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
                        
                        // Отступ справа 80px
                        Spacer()
                            .frame(width: scaledValue(80, for: geometry))
                    }
                    
                    // Отступ от драконов до первой кнопки (190px - 100px = 90px, чтобы поднять кнопки на 100px вверх)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.dragonsToFirstButton - 100, for: geometry, isVertical: true))
                    
                    // Кнопки
                    VStack(spacing: scaledValue(DesignConstants.StartScreen.Spacing.buttonSpacing, for: geometry, isVertical: true)) {
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "question") {
                                navigationManager.navigate(to: .question)
                            }
                        }) {
                            Text("СДЕЛАТЬ РАСКЛАД")
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "dailySign") {
                                navigationManager.navigate(to: .dailySign)
                            }
                        }) {
                            Text("ЗНАК ДНЯ")
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "history") {
                                navigationManager.navigate(to: .history)
                            }
                        }) {
                            Text("ДНЕВНИК ПРЕДСКАЗАНИЙ")
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "tutorial") {
                                navigationManager.navigate(to: .tutorial)
                            }
                        }) {
                            Text("ПОМОЩЬ")
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Нижний отступ (вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.lastButtonToBottom, for: geometry, isVertical: true))
            }
        }
        .onAppear {
            // Показываем туториал при первом запуске
            if !hasSeenTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigationManager.navigate(to: .tutorial)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenDailySign"))) { _ in
            // Открываем экран знака дня при нажатии на уведомление
            print("📱 StartView: получено событие OpenDailySign - открываем экран знака дня")
            navigationManager.navigate(to: .dailySign)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Rampart One regular для иероглифов
    private func rampartOneFont(size: CGFloat) -> Font {
        // Проверяем все возможные варианты имен
        let fontNames = [
            "Rampart One",
            "RampartOne-Regular",
            "RampartOneRegular",
            "RampartOne",
            "Rampart One Regular"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .regular)
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .medium)
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
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        // Если значение относится к CoinsScreen (кнопки), используем его базовые размеры
        if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || 
           value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            }
        } else {
            if isVertical {
                // Для вертикальных отступов используем высоту с учетом safe zone
                // geometry.size уже учитывает safe area в GeometryReader
                scaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
            } else {
                // Для горизонтальных отступов используем ширину
                scaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
            }
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
        // Если размер относится к CoinsScreen (кнопки), используем его базовые размеры
        let widthScaleFactor: CGFloat
        let heightScaleFactor: CGFloat
        
        if size == DesignConstants.CoinsScreen.Typography.buttonTextSize {
            widthScaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            widthScaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
        }
        
        // Используем минимальный коэффициент для сохранения пропорций макета
        // Это гарантирует, что шрифты будут соответствовать пропорциям исходного макета
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        
        return size * scaleFactor
    }
}

// Кастомный стиль кнопки, который делает кнопку красной при нажатии
struct RedTapButtonStyle: ButtonStyle {
    let isTapped: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isPressed || isTapped 
                    ? DesignConstants.StartScreen.Colors.titleRed 
                    : DesignConstants.StartScreen.Colors.buttonBlue
            )
            .opacity(1.0) // Убираем изменение прозрачности
            .scaleEffect(1.0) // Убираем изменение размера
    }
}
