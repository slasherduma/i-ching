import SwiftUI
import UIKit

struct DailySignView: View {
    // ВРЕМЕННО: для тестирования дизайна - сбрасывает состояние при каждом открытии
    var resetForTesting: Bool = false
    
    // Нужно для MenuBarView (TopBar из расклада)
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var hexagram: Hexagram?
    @State private var lines: [Line] = []
    @State private var isGenerating = false
    @State private var showResult = false
    @State private var showHistory = false
    @State private var hasDailySignForToday = false
    
    // Форматирование даты в формате 08/01/2026 (только дата, без времени)
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
    }
    
    // Форматирование даты в старом формате (для экрана с результатом)
    private var formattedDateLong: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter.string(from: Date())
    }
    
    // Форматирование времени
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    // Форматирование даты и времени в формате 08/01/2026 6:30 PM
    private var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
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
                        // Результат с гексаграммой - используем тот же layout-паттерн, что в ResultView/HexagramView
                        VStack(spacing: 0) {
                            // Дата в формате 07/01/2026
                            // Позиция: на 80px над гексаграммой
                            // Гексаграмма на topToHexagram (360px), значит дата на 360 - 80 = 280px
                            let datePosition = scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram - 80, for: geometry, isVertical: true)
                            
                            Spacer()
                                .frame(height: datePosition)
                            
                            // Дата (центрирована)
                            Text(formattedDate)
                                .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                .frame(maxWidth: .infinity)
                            
                            // Отступ от даты до гексаграммы (80px)
                            Spacer()
                                .frame(height: scaledValue(80, for: geometry, isVertical: true))
                            
                            // Гексаграмма - используем те же константы, что в HexagramView/ResultView
                            // Позиция: topToHexagram (360px от верха) - как в раскладе
                            VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                                ForEach(Array(lines.reversed()), id: \.id) { line in
                                    LineView(line: line, geometry: geometry)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Отступ от низа гексаграммы до названия
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.hexagramBottomToName, for: geometry, isVertical: true))
                            
                            // Название гексаграммы (центрировано) - формат: 53 — ПОСТЕПЕННОСТЬ
                            Text("\(hexagram.number) — \(hexagram.name.uppercased())")
                                .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                .frame(maxWidth: .infinity)
                            
                            // Отступ от названия до короткого абзаца
                            Spacer()
                                .frame(height: scaledValue(DesignConstants.DailySignScreen.Spacing.nameToShortParagraph, for: geometry, isVertical: true))
                            
                            // Короткий абзац (центрированный, Roboto Mono Light 22)
                            if let keyPhrase = hexagram.keyPhrase {
                                Text(keyPhrase)
                                    .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
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
                            // Используем ту же логику формирования текста, что и в ResultView (2-3 предложения)
                            // Каждое предложение - с новой строки (отдельный абзац)
                            let bodyText: String = {
                                // Используем generalStrategy если есть, иначе 2-3 предложения из interpretation
                                if let generalStrategy = hexagram.generalStrategy {
                                    let sentences = generalStrategy.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    // Берем 2-3 предложения, каждое с новой строки
                                    let count = min(sentences.count, 3)
                                    if count > 0 {
                                        return sentences.prefix(count).map { $0 + "." }.joined(separator: "\n")
                                    }
                                    return generalStrategy
                                } else {
                                    let sentences = hexagram.interpretation.components(separatedBy: ".").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    // Берем 2-3 предложения, каждое с новой строки
                                    let count = min(sentences.count, 3)
                                    if count > 0 {
                                        return sentences.prefix(count).map { $0 + "." }.joined(separator: "\n")
                                    }
                                    return hexagram.interpretation
                                }
                            }()
                            
                            // Основной текст с padding 80px слева и справа, выровнен по центру (Roboto Mono Light 22)
                            Text(bodyText)
                                .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                .padding(.horizontal, scaledValue(80, for: geometry))
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Отступ от описания до текста о следующем знаке
                            Spacer()
                                .frame(height: scaledValue(40, for: geometry, isVertical: true))
                            
                            // Текст о следующем знаке дня
                            Text("Новый знак дня можно будет получить завтра.")
                                .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue.opacity(0.7))
                                .padding(.horizontal, scaledValue(80, for: geometry))
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Гибкий отступ для выталкивания контента вверх (same as ResultView)
                            Spacer()
                        }
                        .highPriorityGesture(
                            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                                .onEnded { value in
                                    let horizontalMovement = value.translation.width
                                    let verticalMovement = abs(value.translation.height)
                                    
                                    // Проверяем, что это горизонтальный свайп (движение по горизонтали больше, чем по вертикали)
                                    if abs(horizontalMovement) > abs(verticalMovement) {
                                        // Стандартный жест "назад" iOS: свайп слева направо от левого края
                                        // Проверяем, что жест начинается от левого края (в пределах первых 50px)
                                        // и движение вправо больше 100px
                                        if value.startLocation.x < 50 && horizontalMovement > 100 {
                                            navigationManager.popToRoot()
                                        }
                                    }
                                }
                        )
                    } else {
                        // Начальный экран
                        ZStack {
                            VStack(spacing: 0) {
                                // Отступ сверху до заголовка: 100px от top bar меню (как в раскладе)
                                Spacer()
                                    .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu + DesignConstants.CoinsScreen.Spacing.menuToCounter, for: geometry, isVertical: true))
                                
                                // Заголовок "ЗНАК ДНЯ"
                                Text("ЗНАК ДНЯ")
                                    .font(robotoMonoLightFont(size: scaledFontSize(36, for: geometry)))
                                    .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                                    .frame(maxWidth: .infinity)
                                
                                // Гибкий отступ для выталкивания кнопки вниз
                                Spacer()
                            }
                            
                            // Картинка sun по центру экрана, растянутая до отступов 48px от краёв
                            Group {
                                if let uiImage = UIImage(named: "sun") {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else if let url = Bundle.main.url(forResource: "sun", withExtension: "svg"),
                                          let image = UIImage(contentsOfFile: url.path) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    Image("sun")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(scaledValue(48, for: geometry))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                ButtonSoundService.shared.playRandomSound()
                                handleGetSignAction()
                            }
                            
                            // Дата в формате 07/01/2026 по центру экрана
                            Text(formattedDate)
                                .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                                .foregroundColor(DesignConstants.DailySignScreen.Colors.buttonTextColor)
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
                                rightAction: { navigationManager.popToRoot() },
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
                                    handleGetSignAction()
                                },
                                lift: DesignConstants.Layout.ctaLiftHigh,
                                geometry: geometry
                            )
                            .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
                        }
                    }
                }
                // TopBar: ровно тот же MenuBarView, что и на экранах расклада (Coins/Hexagram/Result)
                .overlay(alignment: .top) {
                    MenuBarView(geometry: geometry, onDismiss: { navigationManager.popToRoot() })
                        .environmentObject(navigationManager)
                }
            }
        }
        .background(DesignConstants.DailySignScreen.Colors.backgroundBeige)
        .ignoresSafeArea()
        .gesture(
            DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onEnded { value in
                    let horizontalMovement = value.translation.width
                    let verticalMovement = abs(value.translation.height)
                    
                    // Проверяем, что это горизонтальный свайп (движение по горизонтали больше, чем по вертикали)
                    if abs(horizontalMovement) > verticalMovement {
                        // Стандартный жест "назад" iOS: свайп слева направо от левого края экрана
                        if value.startLocation.x < 50 && horizontalMovement > 100 {
                            navigationManager.popToRoot()
                        }
                    }
                }
        )
        .fullScreenCover(isPresented: $showHistory) {
            HistoryView()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToStartView"))) { _ in
            // Закрываем экран при получении уведомления о возврате на стартовый экран
            navigationManager.popToRoot()
        }
        .onAppear {
            print("👁️ DailySignView onAppear вызван")
            print("📊 onAppear: hexagram = \(hexagram != nil ? "есть (\(hexagram?.number ?? 0))" : "nil"), isGenerating = \(isGenerating)")
            
            // ВРЕМЕННО: для тестирования - сбрасываем состояние при каждом открытии
            if resetForTesting {
                print("🧪 ТЕСТОВЫЙ РЕЖИМ: сбрасываем состояние знака дня")
                StorageService.shared.resetDailySign()
                self.hexagram = nil
                self.lines = []
                self.hasDailySignForToday = false
                self.showResult = false
                self.isGenerating = false
            }
            
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
    /// Использует те же правила масштабирования, что и в HexagramView/ResultView для идентичного позиционирования
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        // Если значение относится к CoinsScreen (кнопки, позиция гексаграммы), используем его базовые размеры
        // Это гарантирует, что гексаграмма будет в том же месте на обоих экранах
        if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || 
           value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding ||
           value == DesignConstants.CoinsScreen.Spacing.topToHexagram ||
           value == DesignConstants.CoinsScreen.Spacing.topToHexagram - 80 ||
           value == DesignConstants.CoinsScreen.Sizes.lineSpacing ||
           value == DesignConstants.CoinsScreen.Sizes.hexagramTotalHeight ||
           value == 80 || // 80px над гексаграммой
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
    
    /// Создает View с отступом первой строки (красная строка) для каждого абзаца
    private func textWithParagraphIndent(
        _ text: String,
        font: Font,
        color: Color,
        firstLineIndent: CGFloat,
        geometry: GeometryProxy
    ) -> some View {
        let fontSize = scaledFontSize(DesignConstants.DailySignScreen.Typography.bodyTextSize, for: geometry)
        
        // Разделяем текст на абзацы (по \n)
        let paragraphs = text.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        // Используем VStack с отдельными Text для каждого предложения с отступом
        return VStack(alignment: .leading, spacing: fontSize * 0.3) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { index, paragraph in
                Text(paragraph)
                    .font(helveticaNeueThinFont(size: fontSize))
                    .foregroundColor(color)
                    .padding(.leading, firstLineIndent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, scaledValue(DesignConstants.DailySignScreen.Spacing.bodyTextHorizontalPadding, for: geometry))
        .frame(maxWidth: .infinity, alignment: .leading)
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
            navigationManager.popToRoot()
        }
    }
    
    /// Обработка нажатия для получения знака дня (используется и кнопкой, и солнцем)
    private func handleGetSignAction() {
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
    }
}
