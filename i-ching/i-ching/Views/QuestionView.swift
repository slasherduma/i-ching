import SwiftUI

struct QuestionView: View {
    @State private var question: String = ""
    @State private var showCoins = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Бежевый фон
                DesignConstants.QuestionScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Отступ сверху до заголовка
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.topToTitle, for: geometry, isVertical: true))
                    
                    // Заголовок "СФОРМУЛИРУЙТЕ ВОПРОС"
                    Text("СФОРМУЛИРУЙТЕ ВОПРОС")
                        .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.titleSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.titleHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Отступ от заголовка до параграфа
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.titleToFirstParagraph + DesignConstants.QuestionScreen.Spacing.betweenParagraphs, for: geometry, isVertical: true))
                    
                    // Параграф
                    Text("Формулировка не влияет на ответ.\nВажно лишь удерживать вопрос в сознании во время броска монет")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.paragraphSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    // Отступ от второго параграфа до поля ввода
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.secondParagraphToInput, for: geometry, isVertical: true))
                    
                    // Поле ввода
                    TextField("Запишите ваш вопрос здесь, чтобы потом легко найти его в дневнике...", text: $question, axis: .vertical)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .multilineTextAlignment(.center)
                        .lineLimit(3...10)
                    
                    // Отступ от поля ввода до кнопок
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.inputToButtons, for: geometry, isVertical: true))
                    
                    // Кнопки (одна слева, одна справа)
                    HStack {
                        // Кнопка "БРОСИТЬ МОНЕТЫ" слева
                        Button(action: {
                            showCoins = true
                        }) {
                            Text("БРОСИТЬ МОНЕТЫ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.buttonSize, for: geometry)))
                                .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        }
                        .padding(.leading, scaledValue(DesignConstants.QuestionScreen.Spacing.buttonHorizontalPadding, for: geometry))
                        
                        Spacer()
                        
                        // Кнопка "ПРОПУСТИТЬ" справа
                        Button(action: {
                            showCoins = true
                        }) {
                            Text("ПРОПУСТИТЬ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.buttonSize, for: geometry)))
                                .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        }
                        .padding(.trailing, scaledValue(DesignConstants.QuestionScreen.Spacing.buttonHorizontalPadding, for: geometry))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Отступ от кнопок до нижнего края
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.buttonsToBottom, for: geometry, isVertical: true))
                }
            }
        }
        .fullScreenCover(isPresented: $showCoins) {
            CoinsView(question: question.isEmpty ? nil : question)
                .transition(.opacity)
        }
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
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            // Для вертикальных отступов используем высоту с учетом safe zone
            // geometry.size уже учитывает safe area в GeometryReader
            scaleFactor = geometry.size.height / DesignConstants.QuestionScreen.baseScreenHeight
        } else {
            // Для горизонтальных отступов используем ширину
            scaleFactor = geometry.size.width / DesignConstants.QuestionScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// В Figma макет 660×1434 @1x, используем минимальный коэффициент для сохранения пропорций
    /// Это гарантирует, что шрифты не будут слишком большими на узких экранах
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        // Вычисляем коэффициенты масштабирования по ширине и высоте
        let widthScaleFactor = geometry.size.width / DesignConstants.QuestionScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.QuestionScreen.baseScreenHeight
        
        // Используем минимальный коэффициент для сохранения пропорций макета
        // Это гарантирует, что шрифты будут соответствовать пропорциям исходного макета
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        
        return size * scaleFactor
    }
}


