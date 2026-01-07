import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var question: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    @State private var swipeProgress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Отступ сверху до заголовка
                Spacer()
                    .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.topToTitle, for: geometry, isVertical: true))
                
                // Заголовок "СФОРМУЛИРУЙТЕ ВОПРОС"
                Text("СФОРМУЛИРУЙТЕ ВОПРОС")
                        .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                
                // Отступ от заголовка до параграфа (уменьшен на 20%)
                Spacer()
                    .frame(height: scaledValue((DesignConstants.QuestionScreen.Spacing.titleToFirstParagraph + DesignConstants.QuestionScreen.Spacing.betweenParagraphs) * 0.8, for: geometry, isVertical: true))
                
                // Параграф
                Text("Формулировка не влияет на ответ.\nВажно лишь удерживать вопрос в сознании во время броска монет")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.paragraphSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                
                // Отступ от второго параграфа до поля ввода (уменьшен на 20%)
                Spacer()
                    .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.secondParagraphToInput * 0.8, for: geometry, isVertical: true))
                
                // Поле ввода с placeholder
                ZStack(alignment: .center) {
                        TextField("", text: $question, axis: .vertical)
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry)))
                            .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                            .focused($isTextFieldFocused)
                            .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                            .multilineTextAlignment(.center)
                            .lineLimit(3...10)
                            .textFieldStyle(.plain)
                        
                        // Кастомный placeholder, который виден на всех устройствах
                        // Показываем placeholder когда поле пустое (даже при фокусе, чтобы пользователь понимал, что можно вводить)
                        if question.isEmpty {
                            Text("Запишите ваш вопрос здесь, чтобы потом легко найти его в дневнике...")
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry)))
                                .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                                .allowsHitTesting(false)
                        }
                }
                
                // Отступ от поля ввода до кнопок
                // Когда клавиатура открыта - используем старую логику (inputToButtons - keyboardHeight + 60)
                // Когда клавиатура закрыта - корректируем отступ так, чтобы кнопки были на той же высоте, что и на CoinsView
                let baseSpacing = scaledValue(DesignConstants.QuestionScreen.Spacing.inputToButtons, for: geometry, isVertical: true)
                let bottomSpacingDiff = scaledValue(DesignConstants.CoinsScreen.Spacing.buttonToBottom - DesignConstants.QuestionScreen.Spacing.buttonsToBottom, for: geometry, isVertical: true)
                let adjustedSpacing = keyboardHeight > 0 
                    ? baseSpacing - keyboardHeight + 60  // Старая логика при открытой клавиатуре
                    : baseSpacing + bottomSpacingDiff   // Добавляем разницу в отступах снизу, чтобы кнопки были на той же высоте
                
                Spacer()
                    .frame(height: max(0, adjustedSpacing))
                
                // Кнопки (одна слева, одна справа)
                HStack {
                        // Кнопка "ПРОПУСТИТЬ" слева
                        Button(action: {
                            navigationManager.navigate(to: .coins(question: question.isEmpty ? nil : question))
                        }) {
                            Text("ПРОПУСТИТЬ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                        }
                        .padding(.leading, scaledValue(40, for: geometry))
                        
                        Spacer()
                        
                        // Кнопка "БРОСИТЬ МОНЕТЫ" справа
                        Button(action: {
                            navigationManager.navigate(to: .coins(question: question.isEmpty ? nil : question))
                        }) {
                            Text("БРОСИТЬ МОНЕТЫ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                        }
                        .padding(.trailing, scaledValue(40, for: geometry))
                }
                .frame(maxWidth: .infinity)
                
                // Отступ от кнопок до нижнего края
                // Когда клавиатура закрыта - используем отступ как на CoinsView (164px)
                // Когда клавиатура открыта - используем старый отступ (156px)
                Spacer()
                    .frame(height: keyboardHeight > 0 
                        ? scaledValue(DesignConstants.QuestionScreen.Spacing.buttonsToBottom, for: geometry, isVertical: true)
                        : scaledValue(DesignConstants.CoinsScreen.Spacing.buttonToBottom, for: geometry, isVertical: true))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
        .overlay(
            // Затемнение при свайпе
            Color.black.opacity(swipeProgress * 0.3)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        )
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    // Проверяем, что свайп начинается от левого края (в пределах 30 пикселей)
                    if value.startLocation.x < 30 && value.translation.width > 0 {
                        // Ограничиваем прогресс от 0 до 1
                        swipeProgress = min(1.0, value.translation.width / 200)
                    }
                }
                .onEnded { value in
                    // Если свайп достаточно длинный (больше 100 пикселей), закрываем экран
                    if value.startLocation.x < 30 && value.translation.width > 100 {
                        navigationManager.pop()
                    } else {
                        // Иначе возвращаем затемнение в исходное состояние
                        withAnimation(.spring()) {
                            swipeProgress = 0
                        }
                    }
                }
        )
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Druk Wide Cyr Medium для заголовка и кнопок
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
    
    /// Создает шрифт Roboto Mono Thin для параграфов
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        // Пробуем разные варианты имен для variable font
        let fontNames = [
            "Roboto Mono",
            "RobotoMono",
            "RobotoMono-VariableFont_wght",
            "RobotoMono Variable",
            "Roboto Mono Variable",
            "Roboto Mono Thin",
            "RobotoMono-Thin",
            "RobotoMonoThin"
        ]
        
        // Проверяем все доступные шрифты в системе для отладки
        #if DEBUG
        let availableFonts = UIFont.familyNames.filter { $0.contains("Roboto") || $0.contains("roboto") }
        if !availableFonts.isEmpty {
            print("Available Roboto fonts: \(availableFonts)")
            for family in availableFonts {
                let fonts = UIFont.fontNames(forFamilyName: family)
                print("  Family '\(family)': \(fonts)")
            }
        }
        #endif
        
        for fontName in fontNames {
            if let font = UIFont(name: fontName, size: size) {
                #if DEBUG
                print("Found Roboto Mono font: \(fontName)")
                #endif
                return .custom(fontName, size: size)
            }
        }
        
        // Если не нашли, пробуем найти через семейство
        if let robotoFamily = UIFont.familyNames.first(where: { $0.lowercased().contains("roboto") && $0.lowercased().contains("mono") }) {
            let fonts = UIFont.fontNames(forFamilyName: robotoFamily)
            if let firstFont = fonts.first {
                #if DEBUG
                print("Using Roboto Mono from family: \(robotoFamily), font: \(firstFont)")
                #endif
                return .custom(firstFont, size: size)
            }
        }
        
        // Fallback на системный моноширинный шрифт
        #if DEBUG
        print("Roboto Mono not found, using system monospaced font")
        #endif
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
    /// Создает шрифт Helvetica Neue Light для placeholder
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .light)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    /// Использует фиксированные размеры экрана, чтобы размеры не менялись при появлении клавиатуры
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let scaleFactor: CGFloat
        if isVertical {
            // Для вертикальных отступов используем высоту экрана (без учета клавиатуры)
            // Если значение относится к CoinsScreen, используем его базовые размеры
            if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding {
                scaleFactor = screenSize.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = screenSize.height / DesignConstants.QuestionScreen.baseScreenHeight
            }
        } else {
            // Для горизонтальных отступов используем ширину экрана
            // Если значение относится к CoinsScreen, используем его базовые размеры
            if value == 40 {
                // Для отступов 40px используем базовые размеры CoinsScreen
                scaleFactor = screenSize.width / DesignConstants.CoinsScreen.baseScreenWidth
            } else {
                scaleFactor = screenSize.width / DesignConstants.QuestionScreen.baseScreenWidth
            }
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует фиксированные размеры экрана, чтобы шрифты не менялись при появлении клавиатуры
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        // Вычисляем коэффициенты масштабирования по ширине и высоте экрана
        // Если размер относится к CoinsScreen, используем его базовые размеры
        let widthScaleFactor: CGFloat
        let heightScaleFactor: CGFloat
        
        if size == DesignConstants.CoinsScreen.Typography.buttonTextSize {
            widthScaleFactor = screenSize.width / DesignConstants.CoinsScreen.baseScreenWidth
            heightScaleFactor = screenSize.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            widthScaleFactor = screenSize.width / DesignConstants.QuestionScreen.baseScreenWidth
            heightScaleFactor = screenSize.height / DesignConstants.QuestionScreen.baseScreenHeight
        }
        
        // Используем минимальный коэффициент для сохранения пропорций макета
        // Это гарантирует, что шрифты будут соответствовать пропорциям исходного макета
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        
        return size * scaleFactor
    }
}


