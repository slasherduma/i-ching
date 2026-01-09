import SwiftUI

struct ReadingDetailView: View {
    let reading: Reading
    let onDismiss: (() -> Void)?
    @State private var showDeleteConfirmation = false
    
    init(reading: Reading, onDismiss: (() -> Void)? = nil) {
        self.reading = reading
        self.onDismiss = onDismiss
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter
    }
    
    // Загрузка полной гексаграммы по номеру
    private var hexagram: Hexagram? {
        Hexagram.findByNumber(reading.hexagramNumber)
    }
    
    // Загрузка второй гексаграммы, если есть
    private var secondHexagram: Hexagram? {
        guard let secondNumber = reading.secondHexagramNumber else { return nil }
        return Hexagram.findByNumber(secondNumber)
    }
    
    // Преобразование LineData в Line
    private var lines: [Line] {
        reading.lines.map { lineData in
            Line(isYang: lineData.isYang, isChanging: lineData.isChanging, position: lineData.position)
        }
    }
    
    // Меняющиеся линии
    private var changingLines: [Line] {
        lines.filter { $0.isChanging }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                DesignConstants.ReadingDetailScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Заголовок
                    HStack {
                        Button(action: withButtonSound {
                            onDismiss?()
                        }) {
                            Text("Назад")
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.backButtonSize, for: geometry)))
                                .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        }
                        .padding(.leading, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.headerHorizontalPadding, for: geometry))
                        
                        Spacer()
                        
                        Text("Расклад")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.titleSize, for: geometry)))
                            .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        
                        Spacer()
                        
                        Text("Назад")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.backButtonSize, for: geometry)))
                            .foregroundColor(.clear)
                            .padding(.trailing, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.headerHorizontalPadding, for: geometry))
                    }
                    .padding(.top, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.headerTop, for: geometry, isVertical: true))
                    .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.headerBottom, for: geometry, isVertical: true))
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Дата
                            Text(dateFormatter.string(from: reading.date))
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                                .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue.opacity(0.6))
                                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                                .padding(.top, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.contentTop, for: geometry, isVertical: true))
                                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
                            
                            // Вопрос
                            if let question = reading.question, !question.isEmpty {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Вопрос")
                                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                                    
                                    Text(question)
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
                            }
                            
                            // Гексаграмма
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Гексаграмма")
                                    .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                    .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                                
                                Text("\(reading.hexagramNumber). \(reading.hexagramName)")
                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                    .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                                
                                if let hexagram = hexagram, let image = hexagram.image {
                                    Text("Образ: \(image)")
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue.opacity(0.6))
                                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                                }
                                
                                if let secondHexagram = secondHexagram {
                                    Text("Вторая гексаграмма: \(secondHexagram.number). \(secondHexagram.name)")
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue.opacity(0.6))
                                }
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
                            
                            // Полная интерпретация
                            if let hexagram = hexagram {
                                fullInterpretationView(hexagram: hexagram, geometry: geometry)
                            } else {
                                // Fallback на сохраненную интерпретацию, если гексаграмма не найдена
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Интерпретация")
                                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                                    
                                    Text(reading.interpretation)
                                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
                            }
                            
                            // Кнопка удаления
                            Button(action: withButtonSound {
                                showDeleteConfirmation = true
                            }) {
                                Text("УДАЛИТЬ")
                                    .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.deleteButtonSize, for: geometry)))
                                    .foregroundColor(Color(hex: "FF3636"))
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.top, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.deleteButtonTop, for: geometry, isVertical: true))
                            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.deleteButtonBottom, for: geometry, isVertical: true))
                        }
                    }
                }
            }
        }
        .alert("Удалить расклад?", isPresented: $showDeleteConfirmation) {
            Button("Отмена", role: .cancel) {
                ButtonSoundService.shared.playRandomSound()
            }
            Button("Удалить", role: .destructive) {
                ButtonSoundService.shared.playRandomSound()
                deleteReading()
            }
        }
    }
    
    private func deleteReading() {
        StorageService.shared.deleteReading(reading)
        onDismiss?()
    }
    
    // Полное представление интерпретации
    @ViewBuilder
    private func fullInterpretationView(hexagram: Hexagram, geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Ключевая фраза
            if let keyPhrase = hexagram.keyPhrase {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ключевая фраза")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    Text(keyPhrase)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Основная интерпретация
            VStack(alignment: .leading, spacing: 0) {
                Text("Интерпретация")
                    .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                    .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                
                Text(hexagram.interpretation)
                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            
            // Общая стратегия
            if let generalStrategy = hexagram.generalStrategy {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Общая стратегия")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    Text(generalStrategy)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Стратегия лидера
            if let leadershipStrategy = hexagram.leadershipStrategy {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Стратегия лидера")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    Text(leadershipStrategy)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Стратегия подчиненного
            if let subordinateStrategy = hexagram.subordinateStrategy {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Стратегия подчиненного")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    Text(subordinateStrategy)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Текст по меняющимся линиям
            if !changingLines.isEmpty, let lineTexts = hexagram.lineTexts, !lineTexts.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Текст по меняющимся линиям")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    ForEach(changingLines.sorted(by: { $0.position < $1.position }), id: \.id) { line in
                        let position = line.position - 1
                        if position >= 0 && position < lineTexts.count {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Линия \(line.position)")
                                    .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue.opacity(0.6))
                                    .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                                
                                Text(lineTexts[position])
                                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                    .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
                        }
                    }
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Практические шаги
            if let practicalAdvice = hexagram.practicalAdvice, !practicalAdvice.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Практические шаги")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    ForEach(Array(practicalAdvice.enumerated()), id: \.offset) { index, item in
                        HStack(alignment: .top, spacing: scaledValue(8, for: geometry)) {
                            Text("\(index + 1).")
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                            
                            Text(item)
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                                .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.bottom, index < practicalAdvice.count - 1 ? scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true) : 0)
                    }
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Вопросы для размышления
            if let questions = hexagram.reflectionQuestions, !questions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Для размышления")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue.opacity(1.0))
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    ForEach(questions, id: \.self) { question in
                        Text("• \(question)")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                    }
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
            
            // Вторая гексаграмма (тенденция)
            if let secondHexagram = secondHexagram {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Тенденция")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.sectionLabelSize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionLabelBottom, for: geometry, isVertical: true))
                    
                    Text("\(secondHexagram.number). \(secondHexagram.name)")
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                    
                    if let keyPhrase = secondHexagram.keyPhrase {
                        Text(keyPhrase)
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                            .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.paragraphSpacing, for: geometry, isVertical: true))
                    }
                    
                    Text(secondHexagram.interpretation)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.ReadingDetailScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.ReadingDetailScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.horizontalPadding, for: geometry))
                .padding(.bottom, scaledValue(DesignConstants.ReadingDetailScreen.Spacing.sectionSpacing, for: geometry, isVertical: true))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Helvetica Neue Light
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
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.ReadingDetailScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.ReadingDetailScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.ReadingDetailScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.ReadingDetailScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}
