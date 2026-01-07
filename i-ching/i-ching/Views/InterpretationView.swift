import SwiftUI

struct InterpretationView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    let secondHexagram: Hexagram?
    @State private var showAdvanced = false
    @State private var selectedRole: UserRole = .leader
    @Environment(\.dismiss) var dismiss
    
    private var interpretation: InterpretationResult {
        InterpretationService.shared.generateInterpretation(
            hexagram: hexagram,
            lines: lines,
            question: question,
            secondHexagram: secondHexagram
        )
    }
    
    private var currentStrategy: String? {
        switch selectedRole {
        case .leader:
            return hexagram.leadershipStrategy ?? hexagram.generalStrategy
        case .subordinate:
            return hexagram.subordinateStrategy ?? hexagram.generalStrategy
        }
    }
    
    private var changingLines: [Line] {
        lines.filter { $0.isChanging }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Главный заголовок (keyPhrase) - Helvetica Neue Light 36pt
                        if let keyPhrase = hexagram.keyPhrase {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(keyPhrase)
                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.mainTitleSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.top, scaledValue(DesignConstants.InterpretationScreen.Spacing.topToTitle, for: geometry, isVertical: true))
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.titleBottom, for: geometry, isVertical: true))
                        }
                        
                        // Информация о гексаграмме (номер, название, образ) - Roboto Mono Thin 22pt
                        VStack(alignment: .leading, spacing: 0) {
                            // Номер и название гексаграммы
                            Text("Гексаграмма \(hexagram.number): \(hexagram.name.uppercased())")
                                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.hexagramNumberBottom, for: geometry, isVertical: true))
                            
                            // Образ
                            if let image = hexagram.image {
                                Text("Образ: \(image)")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.hexagramImageBottom, for: geometry, isVertical: true))
                            }
                            
                            // Качества (теги)
                            if let qualities = hexagram.qualities, !qualities.isEmpty {
                                QualitiesView(qualities: qualities, geometry: geometry)
                                    .padding(.top, scaledValue(DesignConstants.InterpretationScreen.Spacing.qualitiesTop, for: geometry, isVertical: true))
                                
                                // Разделитель под тегами (выровнен по левому краю с padding 48px)
                                Rectangle()
                                    .fill(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .frame(height: 1)
                                    .padding(.top, scaledValue(DesignConstants.InterpretationScreen.Spacing.dividerTop, for: geometry, isVertical: true))
                            }
                        }
                        .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                        .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.hexagramInfoBlockBottom, for: geometry, isVertical: true))
                        
                        // Блок "Сейчас" - Roboto Mono Thin 22pt для заголовка, Helvetica Neue Light 22pt для текста
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Сейчас")
                                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.nowHeaderBottom, for: geometry, isVertical: true))
                            
                            ForEach(Array(interpretation.now.enumerated()), id: \.offset) { index, sentence in
                                Text(sentence)
                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom, index < interpretation.now.count - 1 ? scaledValue(DesignConstants.InterpretationScreen.Spacing.nowParagraphSpacing, for: geometry, isVertical: true) : 0)
                            }
                        }
                        .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                        .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.nowBlockBottom, for: geometry, isVertical: true))
                        
                        // Выбор роли и стратегия
                        if hexagram.leadershipStrategy != nil || hexagram.subordinateStrategy != nil {
                            VStack(alignment: .leading, spacing: 0) {
                                RoleSelectorView(selectedRole: $selectedRole, geometry: geometry)
                                
                                if let strategy = currentStrategy, !strategy.isEmpty {
                                    Text(strategy)
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.top, scaledValue(DesignConstants.InterpretationScreen.Spacing.strategyTextTop, for: geometry, isVertical: true))
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.roleSelectorBlockBottom, for: geometry, isVertical: true))
                        }
                        
                        // Блок "Что будет меняться"
                        if !changingLines.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Что будет меняться")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.changesHeaderBottom, for: geometry, isVertical: true))
                                
                                if let lineTexts = hexagram.lineTexts, !lineTexts.isEmpty {
                                    ForEach(changingLines.sorted(by: { $0.position < $1.position }), id: \.id) { line in
                                        let position = line.position - 1
                                        if position >= 0 && position < lineTexts.count {
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text("Линия \(line.position)")
                                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.lineHeaderToText, for: geometry, isVertical: true))
                                                
                                                Text(lineTexts[position])
                                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.lineItemBottom, for: geometry, isVertical: true))
                                        }
                                    }
                                } else {
                                    ForEach(interpretation.changes, id: \.self) { change in
                                        Text(change)
                                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.bottom, scaledValue(8, for: geometry, isVertical: true))
                                    }
                                }
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.changesBlockBottom, for: geometry, isVertical: true))
                        }
                        
                        // Блок "Тенденция" (для второй гексаграммы)
                        if let trend = interpretation.trend {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Тенденция")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.trendHeaderBottom, for: geometry, isVertical: true))
                                
                                ForEach(Array(trend.enumerated()), id: \.offset) { index, sentence in
                                    Text(sentence)
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, index < trend.count - 1 ? scaledValue(DesignConstants.InterpretationScreen.Spacing.trendParagraphSpacing, for: geometry, isVertical: true) : 0)
                                }
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.trendBlockBottom, for: geometry, isVertical: true))
                        }
                        
                        // Практические шаги
                        if let practicalAdvice = hexagram.practicalAdvice, !practicalAdvice.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Практические шаги")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.practicalStepsHeaderBottom, for: geometry, isVertical: true))
                                
                                ForEach(Array(practicalAdvice.enumerated()), id: \.offset) { index, item in
                                    HStack(alignment: .top, spacing: scaledValue(4, for: geometry, isVertical: false)) {
                                        Text("\(index + 1).")
                                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                        
                                        Text(item)
                                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.bottom, index < practicalAdvice.count - 1 ? scaledValue(8, for: geometry, isVertical: true) : 0)
                                    .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                                    .padding(.trailing, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                                }
                            }
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.practicalStepsBlockBottom, for: geometry, isVertical: true))
                        } else if !interpretation.practical.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Практические шаги")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.practicalStepsHeaderBottom, for: geometry, isVertical: true))
                                
                                ForEach(Array(interpretation.practical.enumerated()), id: \.offset) { index, item in
                                    HStack(alignment: .top, spacing: scaledValue(4, for: geometry, isVertical: false)) {
                                        Text("\(index + 1).")
                                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                        
                                        Text(item)
                                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.bottom, index < interpretation.practical.count - 1 ? scaledValue(8, for: geometry, isVertical: true) : 0)
                                    .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                                    .padding(.trailing, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                                }
                            }
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.practicalStepsBlockBottom, for: geometry, isVertical: true))
                        }
                        
                        // Вопросы для размышления
                        if let questions = hexagram.reflectionQuestions, !questions.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Для размышления")
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                    .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                                    .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.reflectionHeaderBottom, for: geometry, isVertical: true))
                                
                                ForEach(questions, id: \.self) { question in
                                    Text("• \(question)")
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, scaledValue(8, for: geometry, isVertical: true))
                                        .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                                        .padding(.trailing, scaledValue(DesignConstants.InterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                                }
                            }
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.reflectionBlockBottom, for: geometry, isVertical: true))
                        }
                        
                        // Переключатель углубленного режима
                        let hasAdvancedContent = (!changingLines.isEmpty && hexagram.lineTexts != nil) ||
                                                  hexagram.trigrams != nil ||
                                                  (hexagram.reflectionQuestions != nil && !hexagram.reflectionQuestions!.isEmpty)
                        
                        if hasAdvancedContent {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showAdvanced.toggle()
                                }
                            }) {
                                HStack {
                                    Text(showAdvanced ? "Скрыть подробности" : "Подробнее об этом раскладе")
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue.opacity(0.7))
                                    
                                    Image(systemName: showAdvanced ? "chevron.up" : "chevron.down")
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue.opacity(0.7))
                                }
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.advancedToggleBottom, for: geometry, isVertical: true))
                            
                            // Углубленный режим
                            if showAdvanced {
                                AdvancedInterpretationView(
                                    hexagram: hexagram,
                                    lines: lines,
                                    secondHexagram: secondHexagram,
                                    geometry: geometry
                                )
                                .transition(.opacity.combined(with: .move(edge: .top)))
                                .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.practicalStepsBlockBottom, for: geometry, isVertical: true))
                            }
                        }
                        
                        // Кнопка "Продолжить"
                        Button(action: {
                            navigationManager.navigate(to: .result(hexagram: hexagram, lines: lines, question: question))
                        }) {
                            Text("ПРОДОЛЖИТЬ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                        }
                        .padding(.horizontal, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
                        .padding(.bottom, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonToBottom, for: geometry, isVertical: true))
                    }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Roboto Mono Thin для заголовков и меток
    private func robotoMonoThinFont(size: CGFloat) -> Font {
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
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный моноширинный шрифт
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
        
        // Fallback на системный шрифт
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .medium)
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
                scaleFactor = geometry.size.height / DesignConstants.InterpretationScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.InterpretationScreen.baseScreenWidth
            }
        }
        return value * scaleFactor
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
            widthScaleFactor = geometry.size.width / DesignConstants.InterpretationScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.InterpretationScreen.baseScreenHeight
        }
        
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}

