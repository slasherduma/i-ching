import SwiftUI

struct HexagramView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @State private var showInterpretation = false
    
    private var hasChangingLines: Bool {
        lines.contains { $0.isChanging }
    }
    
    private var secondHexagram: Hexagram? {
        hasChangingLines ? Hexagram.findSecond(byLines: lines) : nil
    }
    
    private var interpretationText: String {
        // Используем generalStrategy, если есть, иначе keyPhrase, иначе interpretation (первые несколько предложений)
        if let generalStrategy = hexagram.generalStrategy {
            // Берем первое предложение из generalStrategy
            let sentences = generalStrategy.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            return sentences.first.map { $0 + "." } ?? generalStrategy
        } else if let keyPhrase = hexagram.keyPhrase {
            return keyPhrase
        } else {
            // Берем первое предложение из interpretation
            let sentences = hexagram.interpretation.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            return sentences.first.map { $0 + "." } ?? hexagram.interpretation
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Бежевый фон
                DesignConstants.HexagramScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Отступ от верха до "Текущее состояние"
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.topToCurrentStateTitle, for: geometry, isVertical: true))
                    
                    // Заголовок "Текущее состояние"
                    Text("Текущее состояние")
                        .font(robotoMonoFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.currentStateTitleSize, for: geometry)))
                        .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                        .frame(maxWidth: .infinity)
                    
                    // Отступ от "Текущее состояние" до первой гексограммы
                    // ВАЖНО: гексограмма должна быть на 259px от верха (как на CoinsScreen)
                    // Вычисляем отступ так, чтобы гексограмма была на правильной позиции
                    let titleTop = scaledValue(DesignConstants.HexagramScreen.Spacing.topToCurrentStateTitle, for: geometry, isVertical: true)
                    let titleFontSize = scaledFontSize(DesignConstants.HexagramScreen.Typography.currentStateTitleSize, for: geometry)
                    let hexagramTop = scaledValue(DesignConstants.HexagramScreen.Spacing.topToFirstHexagram, for: geometry, isVertical: true)
                    let spacingNeeded = hexagramTop - titleTop - titleFontSize
                    
                    Spacer()
                        .frame(height: max(0, spacingNeeded))
                    
                    // Первая гексограмма
                    VStack(spacing: scaledValue(DesignConstants.HexagramScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                        ForEach(Array(lines.reversed()), id: \.id) { line in
                            LineView(line: line, geometry: geometry)
                                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Отступ от первой гексограммы до "Гексограмма 11: МИР"
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.hexagramToLabel, for: geometry, isVertical: true))
                    
                    // "Гексограмма X: ..."
                    Text("Гексограмма \(hexagram.number): \(hexagram.name.uppercased())")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.hexagramLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                        .frame(maxWidth: .infinity)
                    
                    // Отступ от "Гексограмма 11: МИР" до текста интерпретации
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.labelToInterpretation, for: geometry, isVertical: true))
                    
                    // Текст интерпретации
                    Text(interpretationText)
                        .font(helveticaNeueThinFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.interpretationSize, for: geometry)))
                        .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                    
                    // Вторая гексограмма (если есть меняющиеся линии)
                    if let second = secondHexagram {
                        // Отступ от текста интерпретации до "Куда всё движется"
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.interpretationToQuestion, for: geometry, isVertical: true))
                        
                        // Вопрос "Куда всё движется если ничего не менять"
                        Text("Куда всё движется если ничего не менять")
                            .font(robotoMonoFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.questionSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        
                        // Отступ от "Куда всё движется" до второй гексограммы
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.questionToSecondHexagram, for: geometry, isVertical: true))
                        
                        // Вторая гексограмма
                        VStack(spacing: scaledValue(DesignConstants.HexagramScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                            ForEach(Array(lines.reversed()), id: \.id) { line in
                                let changedLine = Line(
                                    isYang: line.isChanging ? !line.isYang : line.isYang,
                                    isChanging: false,
                                    position: line.position
                                )
                                LineView(line: changedLine, geometry: geometry)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Отступ от второй гексограммы до "Гексограмма 14: ..."
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.secondHexagramToLabel, for: geometry, isVertical: true))
                        
                        // "Гексограмма 14: ..."
                        Text("Гексограмма \(second.number): \(second.name.uppercased())")
                            .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.hexagramLabelSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .frame(maxWidth: .infinity)
                        
                        // Отступ от "Гексограмма 14: ..." до кнопки
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.secondLabelToButton, for: geometry, isVertical: true))
                    } else {
                        // Если нет второй гексограммы, добавляем отступ перед кнопкой
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.secondLabelToButton, for: geometry, isVertical: true))
                    }
                    
                    // Гибкий отступ для выталкивания кнопки вниз
                    Spacer()
                    
                    // Кнопка "ПОДРОБНЕЕ"
                    Button(action: {
                        showInterpretation = true
                    }) {
                        Text("ПОДРОБНЕЕ")
                            .font(drukWideCyrFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.buttonSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, scaledValue(DesignConstants.QuestionScreen.Spacing.buttonsToBottom, for: geometry, isVertical: true))
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .fullScreenCover(isPresented: $showInterpretation) {
            InterpretationView(hexagram: hexagram, lines: lines, question: question, secondHexagram: secondHexagram)
                .transition(.opacity)
        }
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.HexagramScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.HexagramScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует минимальный коэффициент для сохранения пропорций
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.HexagramScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.HexagramScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
    
    /// Создает шрифт Druk Wide Cyr Medium
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
    
    /// Создает шрифт Druk Wide Cyr
    private func drukWideCyrFont(size: CGFloat) -> Font {
        let fontNames = [
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
        return .system(size: size, weight: .regular)
    }
    
    /// Создает шрифт Roboto Mono
    private func robotoMonoFont(size: CGFloat) -> Font {
        let fontNames = [
            "RobotoMono-VariableFont_wght",
            "Roboto Mono",
            "RobotoMono-Regular"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный моноширинный шрифт
        return .system(size: size, weight: .regular, design: .monospaced)
    }
    
    /// Создает шрифт Roboto Mono Thin
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "RobotoMono-VariableFont_wght",
            "Roboto Mono",
            "RobotoMono-Thin"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный моноширинный шрифт
        return .system(size: size, weight: .thin, design: .monospaced)
    }
    
    /// Создает шрифт Helvetica Neue Thin
    private func helveticaNeueThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "Helvetica Neue Thin",
            "HelveticaNeue-Thin",
            "HelveticaNeueThin",
            "Helvetica Neue",
            "HelveticaNeue"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .thin)
    }
}
