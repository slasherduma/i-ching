import SwiftUI

struct HexagramView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основной контент - может быть любого размера
                VStack(alignment: .center, spacing: 0) {
                    // Отступ от верха до "Текущее состояние"
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.topToCurrentStateTitle, for: geometry, isVertical: true))
                    
                    // Заголовок "Текущее состояние"
                    Text("Текущее состояние".uppercased())
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.currentStateTitleSize, for: geometry)))
                        .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                        .frame(maxWidth: .infinity)
                    
                    // Отступ от "Текущее состояние" до первой гексограммы
                    // ВАЖНО: гексограмма должна быть на 360px от верха (как на CoinsScreen)
                    // Текст "Текущее состояние" должен быть на 80px над верхней гексаграммой
                    // Используем CoinsScreen.topToHexagram для идентичного масштабирования
                    let hexagramTop = scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram, for: geometry, isVertical: true)
                    let fixedSpacing = scaledValue(80, for: geometry, isVertical: true) // 80px над гексаграммой
                    
                    Spacer()
                        .frame(height: max(0, fixedSpacing))
                    
                    // Гексограмма теперь отображается через overlay в ContentView
                    // Здесь оставляем пустое пространство для правильного позиционирования остальных элементов
                    // Высота гексограммы для резервирования пространства
                    VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                        ForEach(Array(lines.reversed()), id: \.id) { line in
                            // Невидимая линия для резервирования пространства
                            Color.clear
                                .frame(height: scaledValue(DesignConstants.CoinsScreen.Sizes.lineThickness, for: geometry, isVertical: true))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Отступ от первой гексограммы до "Гексограмма 11: МИР"
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.hexagramToLabel, for: geometry, isVertical: true))
                    
                    // Формат: 53 — ПОСТЕПЕННОСТЬ
                    Text("\(hexagram.number) — \(hexagram.name.uppercased())")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.hexagramLabelSize, for: geometry)))
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
                        Text("Куда всё движется если ничего не менять".uppercased())
                            .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.questionSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        
                        // Отступ от "Куда всё движется" до второй гексограммы
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.questionToSecondHexagram, for: geometry, isVertical: true))
                        
                        // Вторая гексограмма
                        // Используем те же размеры, что и на CoinsScreen для идентичного отображения
                        VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                            ForEach(Array(lines.reversed()), id: \.id) { line in
                                let changedLine = Line(
                                    isYang: line.isChanging ? !line.isYang : line.isYang,
                                    isChanging: false,
                                    position: line.position
                                )
                                LineView(line: changedLine, geometry: geometry)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Отступ от второй гексограммы до "Гексограмма 14: ..."
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.secondHexagramToLabel, for: geometry, isVertical: true))
                        
                        // Формат: 53 — ПОСТЕПЕННОСТЬ
                        Text("\(second.number) — \(second.name.uppercased())")
                            .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.hexagramLabelSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .frame(maxWidth: .infinity)
                        
                        // Отступ от "Гексограмма 14: ..." до текста описания
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.HexagramScreen.Spacing.labelToInterpretation, for: geometry, isVertical: true))
                        
                        // Текст описания (как у верхней гексограммы)
                        Text(summaryText(for: second))
                            .font(helveticaNeueThinFont(size: scaledFontSize(DesignConstants.HexagramScreen.Typography.interpretationSize, for: geometry)))
                            .foregroundColor(DesignConstants.HexagramScreen.Colors.textBlue)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        
                        // Отступ от описания второй гексограммы до конца контента
                    }
                    
                    // Контент может быть любого размера
                    Spacer()
                }
            }
            .overlay(alignment: .top) {
                MenuBarView(geometry: geometry, onDismiss: { navigationManager.popToRoot() })
                    .environmentObject(navigationManager)
            }
            .overlay(alignment: .bottom) {
                BottomBar.primary(
                    title: "ПОДРОБНЕЕ",
                    isDisabled: false,
                    action: {
                        let secondHexagram = hasChangingLines ? Hexagram.findSecond(byLines: lines) : nil
                        navigationManager.navigate(to: .interpretation(hexagram: hexagram, lines: lines, question: question, secondHexagram: secondHexagram))
                    },
                    lift: DesignConstants.Layout.ctaLiftSticky,
                    geometry: geometry
                )
                .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
            }
        }
        .onAppear {
            // Обновляем гексограмму в overlay при появлении экрана
            navigationManager.updateHexagramLines(lines)
        }
    }
    
    private var hasChangingLines: Bool {
        lines.contains { $0.isChanging }
    }
    
    private var secondHexagram: Hexagram? {
        hasChangingLines ? Hexagram.findSecond(byLines: lines) : nil
    }
    
    init(hexagram: Hexagram, lines: [Line], question: String?) {
        self.hexagram = hexagram
        self.lines = lines
        self.question = question
    }
    
    private var interpretationText: String {
        summaryText(for: hexagram)
    }

    private func summaryText(for hexagram: Hexagram) -> String {
        // Используем generalStrategy, если есть, иначе keyPhrase, иначе interpretation (первые несколько предложений)
        if let generalStrategy = hexagram.generalStrategy {
            // Берем первое предложение из generalStrategy
            let sentences = generalStrategy
                .components(separatedBy: ".")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            return sentences.first.map { $0 + "." } ?? generalStrategy
        } else if let keyPhrase = hexagram.keyPhrase {
            return keyPhrase
        } else {
            // Берем первое предложение из interpretation
            let sentences = hexagram.interpretation
                .components(separatedBy: ".")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            return sentences.first.map { $0 + "." } ?? hexagram.interpretation
        }
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        // Если значение относится к CoinsScreen (кнопки, позиция гексограммы), используем его базовые размеры
        // Это гарантирует, что гексограмма будет в том же месте на обоих экранах
        if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || 
           value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding ||
           value == DesignConstants.CoinsScreen.Sizes.buttonHeight ||
           value == DesignConstants.CoinsScreen.Spacing.topToHexagram ||
           value == DesignConstants.HexagramScreen.Spacing.topToFirstHexagram ||
           value == DesignConstants.CoinsScreen.Sizes.lineSpacing ||
           value == DesignConstants.HexagramScreen.Sizes.lineSpacing ||
           value == 40 {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            }
        } else {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.HexagramScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.HexagramScreen.baseScreenWidth
            }
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует минимальный коэффициент для сохранения пропорций
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        // Если размер относится к CoinsScreen (кнопки), используем его базовые размеры
        let widthScaleFactor: CGFloat
        let heightScaleFactor: CGFloat
        
        if size == DesignConstants.CoinsScreen.Typography.buttonTextSize {
            widthScaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            widthScaleFactor = geometry.size.width / DesignConstants.HexagramScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.HexagramScreen.baseScreenHeight
        }
        
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
