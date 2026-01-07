import SwiftUI

struct DailySignView: View {
    @State private var hexagram: Hexagram?
    @State private var lines: [Line] = []
    @State private var isGenerating = false
    @State private var showResult = false
    @State private var showHistory = false
    @State private var hasDailySignForToday = false
    @Environment(\.dismiss) var dismiss
    
    // Форматирование даты
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy г."
        return formatter.string(from: Date())
    }
    
    // Форматирование времени
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack {
            // Бежевый фон - сначала задаем фон на верхнем уровне
            DesignConstants.DailySignScreen.Colors.backgroundBeige
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                // Main content VStack - matches ResultView's flow pattern
                VStack(spacing: 0) {
                    if isGenerating {
                        // Индикатор генерации
                        VStack {
                            Spacer()
                            Text("Генерация знака дня...")
                                .font(helveticaNeueLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                            Spacer()
                        }
                    } else if let hexagram = hexagram {
                        // Результат с гексаграммой - matches ResultView's structure
                        VStack(spacing: 0) {
                            // Отступ от верха до даты (с учетом safe zone iPhone)
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.topToDate, for: geometry, isVertical: true) + geometry.safeAreaInsets.top)
                            
                            // Дата и время (центрированы)
                            VStack(spacing: 0) {
                                Text(formattedDate)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.DailySignScreen.Typography.dateSize, for: geometry)))
                                    .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                
                                Text(formattedTime)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.DailySignScreen.Typography.timeSize, for: geometry)))
                                    .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Отступ от блока даты/времени до гексаграммы
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.dateTimeBlockToHexagram, for: geometry, isVertical: true))
                            
                            // Гексаграмма (центрирована)
                            VStack(spacing: scaledValue(DesignConstants.DailySignScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                                ForEach(Array(lines.reversed()), id: \.id) { line in
                                    LineView(line: line, geometry: geometry)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Отступ от низа гексаграммы до названия
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.hexagramBottomToName, for: geometry, isVertical: true))
                            
                            // Название гексаграммы (центрировано)
                            Text("\(hexagram.number) : \(hexagram.name.uppercased())")
                                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.DailySignScreen.Typography.hexagramNameSize, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                .frame(maxWidth: .infinity)
                            
                            // Отступ от названия до короткого абзаца
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.nameToShortParagraph, for: geometry, isVertical: true))
                            
                            // Короткий абзац (центрированный, Roboto Mono Thin)
                            if let keyPhrase = hexagram.keyPhrase {
                                Text(keyPhrase)
                                    .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.DailySignScreen.Typography.shortParagraphSize, for: geometry)))
                                    .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue.opacity(0.7))
                                    .padding(.horizontal, scaledValue(DesignConstants.DailySignScreen.Spacing.bodyTextHorizontalPadding, for: geometry))
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            // Отступ от короткого абзаца до основного текста
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.shortParagraphToBody, for: geometry, isVertical: true))
                            
                            // Основной текст (выровнен по левому краю, Helvetica Neue Thin 22)
                            let bodyText: String = {
                                // Используем generalStrategy если есть, иначе первое предложение из interpretation
                                if let generalStrategy = hexagram.generalStrategy {
                                    let sentences = generalStrategy.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    return sentences.first.map { $0 + "." } ?? generalStrategy
                                } else {
                                    let sentences = hexagram.interpretation.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    return sentences.first.map { $0 + "." } ?? hexagram.interpretation
                                }
                            }()
                            
                            Text(bodyText)
                                .font(helveticaNeueThinFont(size: scaledFontSize(DesignConstants.DailySignScreen.Typography.bodyTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                .padding(.horizontal, scaledValue(DesignConstants.DailySignScreen.Spacing.bodyTextHorizontalPadding, for: geometry))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Гибкий отступ для выталкивания контента вверх (same as ResultView)
                            Spacer()
                        }
                    } else {
                        // Начальный экран
                        VStack(spacing: 0) {
                            // Отступ сверху до заголовка (как в QuestionView)
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.topToTitle, for: geometry, isVertical: true))
                            
                            // Заголовок "ЗНАК ДНЯ"
                            Text("ЗНАК ДНЯ")
                                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.buttonTextColor)
                                .frame(maxWidth: .infinity)
                            
                            // Гибкий отступ для выталкивания кнопки вниз
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .bottom) {
                    if !isGenerating {
                        if hexagram != nil {
                            BottomBar.dual(
                                leftTitle: "СОХРАНИТЬ",
                                leftAction: { saveToHistory() },
                                rightTitle: "ВЫЙТИ В МЕНЮ",
                                rightAction: { dismiss() },
                                lift: DesignConstants.Layout.ctaLiftHigh,
                                geometry: geometry,
                                textColor: .black
                            )
                            .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
                        } else {
                            BottomBar.primary(
                                title: "ПОЛУЧИТЬ ЗНАК",
                                isDisabled: isGenerating,
                                action: {
                                    print("🔘 Кнопка 'ПОЛУЧИТЬ ЗНАК' нажата")
                                    
                                    // Проверяем, есть ли уже знак для сегодня
                                    let hasSign = StorageService.shared.hasDailySignForToday()
                                    print("📊 hasSign: \(hasSign)")
                                    
                                    if hasSign {
                                        // Если знак уже есть, просто загружаем и показываем его
                                        print("🔍 Пытаемся загрузить существующий знак дня")
                                        if let dailySign = StorageService.shared.loadDailySign() {
                                            print("✅ Знак дня загружен: \(dailySign.hexagram.number) - \(dailySign.hexagram.name)")
                                            self.hexagram = dailySign.hexagram
                                            self.lines = dailySign.lines
                                            self.hasDailySignForToday = true
                                            self.showResult = true
                                            print("✅ Состояние обновлено: hexagram = \(dailySign.hexagram.number)")
                                        } else {
                                            print("❌ ОШИБКА: hasSign = true, но loadDailySign() вернул nil!")
                                            // Если знак не загружается, сбрасываем блокировку и генерируем новый
                                            StorageService.shared.resetDailySign()
                                            generateDailySign()
                                        }
                                        return
                                    }
                                    
                                    // Если знака нет, генерируем новый
                                    print("🎲 Начинаем генерацию нового знака дня")
                                    generateDailySign()
                                },
                                lift: DesignConstants.Layout.ctaLiftHigh,
                                geometry: geometry
                            )
                            .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
                        }
                    }
                }
            }
        }
        .background(DesignConstants.DailySignScreen.Colors.backgroundBeige)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showHistory) {
            HistoryView()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToStartView"))) { _ in
            // Закрываем экран при получении уведомления о возврате на стартовый экран
            // Используем transaction без анимации для мгновенного закрытия
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                dismiss()
            }
        }
        .onAppear {
            print("👁️ DailySignView onAppear вызван")
            print("📊 onAppear: hexagram = \(hexagram != nil ? "есть (\(hexagram?.number ?? 0))" : "nil"), isGenerating = \(isGenerating)")
            
            // Проверяем только если hexagram еще не установлен и не идет генерация
            if hexagram == nil && !isGenerating {
                print("🔍 hexagram = nil и не идет генерация, вызываем checkDailySign()")
                checkDailySign()
            } else {
                if hexagram != nil {
                    print("⏭️ hexagram уже установлен (\(hexagram?.number ?? 0)), пропускаем checkDailySign()")
                }
                if isGenerating {
                    print("⏭️ идет генерация, пропускаем checkDailySign()")
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        // Если значение относится к CoinsScreen (кнопки), используем его базовые размеры
        if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || 
           value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding ||
           value == 40 {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            }
        } else if value == DesignConstants.QuestionScreen.Spacing.topToTitle {
            // Если значение относится к QuestionScreen (заголовок), используем его базовые размеры
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.QuestionScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.QuestionScreen.baseScreenWidth
            }
        } else {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.DailySignScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.DailySignScreen.baseScreenWidth
            }
        }
        return value * scaleFactor
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
            widthScaleFactor = geometry.size.width / DesignConstants.DailySignScreen.baseScreenWidth
            heightScaleFactor = geometry.size.height / DesignConstants.DailySignScreen.baseScreenHeight
        }
        
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
    
    /// Вычисляет адаптивный размер шрифта для кнопки, чтобы текст поместился
    private func adaptiveButtonFontSize(text: String, baseSize: CGFloat, availableWidth: CGFloat) -> CGFloat {
        // Пробуем разные размеры шрифта, пока не найдем подходящий
        let testFont = UIFont(name: "Druk Wide Cyr Medium", size: baseSize) ?? UIFont.systemFont(ofSize: baseSize, weight: .medium)
        let textSize = (text as NSString).size(withAttributes: [.font: testFont])
        
        if textSize.width <= availableWidth {
            return baseSize
        }
        
        // Уменьшаем размер пропорционально
        let scaleFactor = availableWidth / textSize.width
        return baseSize * scaleFactor * 0.95 // Небольшой запас
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
    
    /// Создает шрифт Helvetica Neue Thin
    private func helveticaNeueThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "Helvetica Neue Thin",
            "HelveticaNeue-Thin",
            "HelveticaNeueThin",
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
        
        // Fallback на системный шрифт ultraLight (ближайший к Thin)
        return .system(size: size, weight: .ultraLight)
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
        
        return .system(size: size, weight: .medium)
    }
    
    private func checkDailySign() {
        print("🔍 checkDailySign() вызвана")
        print("📊 Текущее состояние: hexagram = \(hexagram != nil ? "есть" : "nil"), isGenerating = \(isGenerating)")
        
        // Не проверяем, если уже есть hexagram и мы не в процессе генерации
        // Это предотвращает сброс состояния после генерации
        if let _ = hexagram, !isGenerating {
            print("⏭️ Пропускаем проверку - hexagram уже установлен")
            return
        }
        
        // Всегда обновляем состояние при проверке
        let hasSign = StorageService.shared.hasDailySignForToday()
        hasDailySignForToday = hasSign
        print("📊 hasSign: \(hasSign)")
        
        if hasSign {
            // Загружаем сохраненный знак дня и сразу показываем его
            print("🔍 checkDailySign: пытаемся загрузить знак дня")
            if let dailySign = StorageService.shared.loadDailySign() {
                print("✅ checkDailySign: знак дня загружен: \(dailySign.hexagram.number) - \(dailySign.hexagram.name)")
                self.hexagram = dailySign.hexagram
                self.lines = dailySign.lines
                self.showResult = true
                print("✅ checkDailySign: состояние обновлено")
            } else {
                print("❌ checkDailySign: ОШИБКА - hasSign = true, но loadDailySign() вернул nil!")
                print("🔄 checkDailySign: сбрасываем блокировку и данные")
                // Если знак не загружается, сбрасываем все и позволяем сгенерировать новый
                StorageService.shared.resetDailySign()
                self.hexagram = nil
                self.lines = []
                self.hasDailySignForToday = false
                self.showResult = false
            }
        } else {
            // Если знака нет, сбрасываем состояние только если мы не в процессе генерации
            if !isGenerating {
                print("🔄 Сбрасываем состояние - знака нет")
                self.hexagram = nil
                self.lines = []
                self.showResult = false
            } else {
                print("⏳ Не сбрасываем состояние - идет генерация")
            }
        }
    }
    
    private func generateDailySign() {
        print("🎯 generateDailySign() вызвана")
        
        // Проверяем еще раз перед генерацией
        let alreadyHasSign = StorageService.shared.hasDailySignForToday()
        print("📊 alreadyHasSign: \(alreadyHasSign)")
        
        if alreadyHasSign {
            // Если знак уже есть, просто загружаем и показываем его
            if let dailySign = StorageService.shared.loadDailySign() {
                print("✅ Загружаем существующий знак")
                self.hexagram = dailySign.hexagram
                self.lines = dailySign.lines
                self.hasDailySignForToday = true
                self.showResult = true
            }
            return
        }
        
        // Блокируем получение знака дня СРАЗУ
        StorageService.shared.lockDailySignForToday()
        print("🔒 Знак дня заблокирован")
        
        // Устанавливаем флаги для предотвращения повторных нажатий
        isGenerating = true
        print("⏳ isGenerating = true")
        
        // Небольшая задержка для UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🎲 Начинаем генерацию линий")
            
            // Генерируем 6 линий автоматически
            var generatedLines: [Line] = []
            for i in 1...6 {
                let isYang = Bool.random()
                let isChanging = Bool.random() && Bool.random() // Реже меняющиеся линии
                generatedLines.append(Line(
                    isYang: isYang,
                    isChanging: isChanging,
                    position: i
                ))
            }
            
            print("📏 Сгенерировано \(generatedLines.count) линий")
            
            // Находим гексаграмму
            let foundHexagram: Hexagram
            if let hexagram = Hexagram.find(byLines: generatedLines) {
                foundHexagram = hexagram
                print("✅ Найдена гексаграмма: \(hexagram.number) - \(hexagram.name)")
            } else {
                // Fallback
                foundHexagram = Hexagram.loadAll().first!
                print("⚠️ Используем fallback гексаграмму: \(foundHexagram.number)")
            }
            
            // Сохраняем знак дня
            StorageService.shared.saveDailySign(hexagram: foundHexagram, lines: generatedLines)
            print("💾 Знак дня сохранен")
            
            // Устанавливаем состояние (мы уже на главном потоке)
            // Важно: обновляем все состояние атомарно
            DispatchQueue.main.async {
                print("🔄 Обновляем состояние на главном потоке")
                self.lines = generatedLines
                self.hexagram = foundHexagram
                self.hasDailySignForToday = true
                self.isGenerating = false
                self.showResult = true
                
                print("✅ Состояние обновлено: hexagram = \(foundHexagram.number), isGenerating = \(self.isGenerating), showResult = \(self.showResult)")
                print("📊 Проверка: hexagram != nil = \(self.hexagram != nil), lines.count = \(self.lines.count)")
            }
        }
    }
    
    private func saveToHistory() {
        guard let hexagram = hexagram else { return }
        
        let secondHexagram = Hexagram.findSecond(byLines: lines)
        let reading = Reading(
            date: Date(),
            question: "Знак дня", // Название для записи в дневнике
            hexagram: hexagram,
            lines: lines,
            secondHexagram: secondHexagram
        )
        
        StorageService.shared.saveReading(reading)
        
        // Показываем подтверждение
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dismiss()
        }
    }
}
