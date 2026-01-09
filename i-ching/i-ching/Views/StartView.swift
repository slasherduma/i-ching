import SwiftUI
import UIKit

struct StartView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var musicService: BackgroundMusicService
    @AppStorage("hasSeenTutorial") private var hasSeenTutorial: Bool = false
    @State private var tappedButtonId: String? = nil
    
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
            let verticalScaleFactor = geometry.size.height / DesignConstants.StartScreen.baseScreenHeight
            let horizontalScaleFactor = geometry.size.width / DesignConstants.StartScreen.baseScreenWidth
            let dragonsHeight = DesignConstants.StartScreen.Spacing.dragonsHeight * verticalScaleFactor
            let dragonsWidth = DesignConstants.StartScreen.Spacing.dragonsWidth * horizontalScaleFactor
            
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                        // Отступ 220pt от верха экрана
                        Spacer()
                            .frame(height: geometry.safeAreaInsets.top + 220)
                        
                        // Отступ до кнопок (заполняет пространство над картинкой)
                        Spacer()
                        
                        // Кнопки
                        VStack(spacing: scaledValue(20, for: geometry, isVertical: true)) {
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "question") {
                                navigationManager.navigate(to: .question)
                            }
                        }) {
                            Text("СДЕЛАТЬ РАСКЛАД")
                                .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "dailySign") {
                                navigationManager.navigate(to: .dailySign)
                            }
                        }) {
                            Text("ЗНАК ДНЯ")
                                .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "history") {
                                navigationManager.navigate(to: .history)
                            }
                        }) {
                            Text("ДНЕВНИК ПРЕДСКАЗАНИЙ")
                                .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                        
                        Button(action: withButtonSound {
                            handleButtonTap(buttonId: "tutorial") {
                                navigationManager.navigate(to: .tutorial(entryPoint: .fromMenu))
                            }
                        }) {
                            Text("ПОМОЩЬ")
                                .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                                .foregroundColor(DesignConstants.StartScreen.Colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(RedTapButtonStyle(isTapped: tappedButtonId == "question"))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Нижний отступ (вертикальный)
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.StartScreen.Spacing.lastButtonToBottom, for: geometry, isVertical: true))
                }
                
                // Hero area - позиционируется на расстоянии 468pt от низа
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: scaledValue(48, for: geometry))
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Image("dragons-hero")
                            .resizable()
                            .scaledToFill()
                            .frame(width: dragonsWidth)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(width: dragonsWidth, height: dragonsHeight, alignment: .bottom)
                    .clipped()
                    
                    Spacer()
                        .frame(width: scaledValue(48, for: geometry))
                }
                .padding(.bottom, scaledValue(440, for: geometry, isVertical: true) + geometry.safeAreaInsets.bottom)
                .offset(y: scaledValue(10, for: geometry, isVertical: true))
                
                // Нижние надписи - позиционируются от самого низа экрана
                VStack {
                    Spacer()
                    HStack {
                        // Левая надпись "i_ching_ver.1.0"
                        Text("i_ching_ver.1.0")
                            .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.buttonBlue)
                            .padding(.leading, scaledValue(48, for: geometry))
                        Spacer()
                        // Правая надпись "made in France"
                        Text("made in France")
                            .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                            .foregroundColor(DesignConstants.StartScreen.Colors.buttonBlue)
                            .padding(.trailing, scaledValue(40, for: geometry))
                    }
                    .padding(.bottom, scaledValue(80, for: geometry, isVertical: true) - geometry.safeAreaInsets.bottom)
                }
            }
            .overlay(alignment: .top) {
                StartMenuBarView(geometry: geometry)
                    .environmentObject(musicService)
            }
        }
        .onAppear {
            // Показываем туториал при первом запуске через NavigationManager для cross fade анимации
            if !hasSeenTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    navigationManager.navigate(to: .tutorial(entryPoint: .firstLaunch))
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
