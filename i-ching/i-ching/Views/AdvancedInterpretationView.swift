import SwiftUI

struct AdvancedInterpretationView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let secondHexagram: Hexagram?
    let geometry: GeometryProxy?
    
    init(hexagram: Hexagram, lines: [Line], secondHexagram: Hexagram?, geometry: GeometryProxy? = nil) {
        self.hexagram = hexagram
        self.lines = lines
        self.secondHexagram = secondHexagram
        self.geometry = geometry
    }
    
    private var changingLines: [Line] {
        lines.filter { $0.isChanging }
    }
    
    var body: some View {
        Group {
            if let geometry = geometry {
                contentView(geometry: geometry)
            } else {
                GeometryReader { geometry in
                    contentView(geometry: geometry)
                }
            }
        }
    }
    
    @ViewBuilder
    private func contentView(geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Разделительная линия
            Rectangle()
                .fill(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                .frame(height: scaledValue(DesignConstants.AdvancedInterpretationScreen.Sizes.dividerHeight, for: geometry, isVertical: true))
                .padding(.top, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.dividerToSectionHeader, for: geometry, isVertical: true))
            
            // Блок "Текст по меняющимся линиям"
            if !changingLines.isEmpty, let lineTexts = hexagram.lineTexts, !lineTexts.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    // Заголовок секции
                    Text("Текст по меняющимся линиям")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                        .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                        .padding(.top, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.dividerToSectionHeader, for: geometry, isVertical: true))
                        .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.sectionHeaderBottom, for: geometry, isVertical: true))
                    
                    // Элементы линий
                    ForEach(Array(changingLines.sorted(by: { $0.position < $1.position }).enumerated()), id: \.element.id) { index, line in
                        let position = line.position - 1
                        if position >= 0 && position < lineTexts.count {
                            VStack(alignment: .leading, spacing: 0) {
                                // Визуализация линии и заголовок
                                HStack(spacing: scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineVisualToLabel, for: geometry)) {
                                    // Визуализация линии
                                    SmallLineView(line: line, geometry: geometry)
                                    
                                    Text("Линия \(line.position)")
                                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                                        .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                                }
                                .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineLeftOffset, for: geometry))
                                .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineLabelToText, for: geometry, isVertical: true))
                                
                                // Текст описания линии
                                Text(lineTexts[position])
                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                                    .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, index == 0 ? 
                                scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineItemTopFirst, for: geometry, isVertical: true) :
                                scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineItemTopOther, for: geometry, isVertical: true))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.lineItemBottom, for: geometry, isVertical: true))
                        }
                    }
                }
                .padding(.horizontal, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.changingLinesBlockBottom, for: geometry, isVertical: true))
            }
            
            // Блок "Объяснение триграмм"
            if let trigrams = hexagram.trigrams {
                VStack(alignment: .leading, spacing: 0) {
                    // Заголовок секции
                    Text("Объяснение триграмм")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                        .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                        .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.horizontalPadding, for: geometry))
                        .padding(.top, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.betweenBlocks, for: geometry, isVertical: true))
                        .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramsHeaderBottom, for: geometry, isVertical: true))
                    
                    // Верхняя триграмма (линии 4-6)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Верхняя триграмма")
                            .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramHeaderToSymbol, for: geometry, isVertical: true))
                        
                        // Визуализация триграммы
                        TrigramView(lines: lines, positions: [4, 5, 6], geometry: geometry)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramSymbolToName, for: geometry, isVertical: true))
                        
                        // Название триграммы
                        Text(trigrams.upper.name)
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.trailing, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramNameToDescription, for: geometry, isVertical: true))
                        
                        // Описание триграммы
                        Text(trigrams.upper.description)
                            .font(helveticaNeueUltraLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.trailing, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                    }
                    .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.betweenTrigrams, for: geometry, isVertical: true))
                    
                    // Нижняя триграмма (линии 1-3)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Нижняя триграмма")
                            .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramHeaderToSymbol, for: geometry, isVertical: true))
                        
                        // Визуализация триграммы
                        TrigramView(lines: lines, positions: [1, 2, 3], geometry: geometry)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramSymbolToName, for: geometry, isVertical: true))
                        
                        // Название триграммы
                        Text(trigrams.lower.name)
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.trailing, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramNameToDescription, for: geometry, isVertical: true))
                        
                        // Описание триграммы
                        Text(trigrams.lower.description)
                            .font(helveticaNeueUltraLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.trailing, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                    }
                }
                .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramsBlockBottom, for: geometry, isVertical: true))
            }
            
            // Блок "Для размышления"
            if let questions = hexagram.reflectionQuestions, !questions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Для размышления")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.labelSize, for: geometry)))
                        .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                        .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.horizontalPadding, for: geometry))
                        .padding(.top, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.trigramsToReflection, for: geometry, isVertical: true))
                        .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.reflectionHeaderBottom, for: geometry, isVertical: true))
                    
                    ForEach(Array(questions.enumerated()), id: \.offset) { index, question in
                        Text("• \(question)")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.AdvancedInterpretationScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, index < questions.count - 1 ? scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.reflectionItemSpacing, for: geometry, isVertical: true) : 0)
                            .padding(.leading, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockLeftPadding, for: geometry))
                            .padding(.trailing, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.bulletBlockRightPadding, for: geometry))
                    }
                }
                .padding(.bottom, scaledValue(DesignConstants.AdvancedInterpretationScreen.Spacing.reflectionBlockBottom, for: geometry, isVertical: true))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Roboto Mono Thin для заголовков и меток
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        // Сначала проверяем Thin варианты (приоритет) - это гарантирует Thin начертание
        let thinFontNames = [
            "Roboto Mono Thin",
            "RobotoMono-Thin",
            "RobotoMonoThin"
        ]
        
        for fontName in thinFontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Если Thin вариант не найден, используем системный fallback с правильным весом
        // чтобы гарантировать Thin начертание (ultraLight соответствует Thin/100)
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
    
    /// Создает шрифт Helvetica Neue UltraLight для описаний триграмм
    private func helveticaNeueUltraLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Helvetica Neue UltraLight",
            "HelveticaNeue-UltraLight",
            "HelveticaNeueUltraLight",
            "Helvetica Neue",
            "HelveticaNeue"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .ultraLight)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.AdvancedInterpretationScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.AdvancedInterpretationScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует минимальный коэффициент для сохранения пропорций макета
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.AdvancedInterpretationScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.AdvancedInterpretationScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}

// MARK: - SmallLineView Component (для AdvancedInterpretationView)

struct SmallLineView: View {
    let line: Line
    let geometry: GeometryProxy
    
    var body: some View {
        Group {
            if line.isYang {
                // Целая линия (ян) - толщина 5px
                Image("Line")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                    .frame(width: scaledValue(68, for: geometry), height: scaledValue(5, for: geometry, isVertical: true))
            } else {
                // Прерывистая линия (инь) - толщина 5px
                Image("Line_s")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(DesignConstants.AdvancedInterpretationScreen.Colors.textBlue)
                    .frame(width: scaledValue(68, for: geometry), height: scaledValue(5, for: geometry, isVertical: true))
            }
        }
    }
    
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.AdvancedInterpretationScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.AdvancedInterpretationScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
}

// MARK: - TrigramView Component

struct TrigramView: View {
    let lines: [Line]
    let positions: [Int]
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: scaledValue(5, for: geometry, isVertical: true)) {
            ForEach(positions, id: \.self) { pos in
                if let line = lines.first(where: { $0.position == pos }) {
                    SmallLineView(line: line, geometry: geometry)
                }
            }
        }
    }
    
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.AdvancedInterpretationScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.AdvancedInterpretationScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
}
