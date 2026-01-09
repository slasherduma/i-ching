import SwiftUI
import UIKit

struct ResultView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @Environment(\.dismiss) var dismiss
    
    // Форматирование даты и времени в одну строку
    private var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        #if DEBUG
        // STEP 4: Uncomment the line below to test UIKitLabel in isolation
        // return DebugUIKitLabelView()
        #endif
        
        GeometryReader { geometry in
            // Calculate bottom padding for content to avoid CTA overlap
            let contentBottomPad = scaledValue(DesignConstants.CoinsScreen.Sizes.buttonHeight, for: geometry, isVertical: true)
                + scaledValue(DesignConstants.Layout.ctaLiftSticky, for: geometry, isVertical: true)
                + DesignConstants.Layout.ctaSafeBottomPadding
                + 12
            
            ZStack {
                // Результат с гексаграммой
                VStack(spacing: 0) {
                    // Дата и время в одну строку
                    // Позиция: на том же уровне, что и счетчик на CoinsView
                    // Отступ от верха: topToMenu (133) + menuToCounter (100) = 233px
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu + DesignConstants.CoinsScreen.Spacing.menuToCounter, for: geometry, isVertical: true))
                    
                    // Дата и время в одну строку (центрированы)
                    Text(formattedDateTime)
                        .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                        .foregroundColor(DesignConstants.DailySignScreen.Colors.textBlue)
                        .frame(maxWidth: .infinity)
                    
                    // Отступ от даты до гексаграммы
                    // Гексаграмма на 360px, дата на 233px, значит отступ = 360 - 233 = 127px
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram, for: geometry, isVertical: true) - scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu + DesignConstants.CoinsScreen.Spacing.menuToCounter, for: geometry, isVertical: true))
                    
                    // Гексаграмма теперь отображается через overlay в ContentView
                    // Здесь оставляем пустое пространство для правильного позиционирования остальных элементов
                    // Резервирование пространства для гексаграммы (отображается через overlay)
                    VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                        ForEach(Array(lines.reversed()), id: \.id) { line in
                            // Невидимая линия для резервирования пространства
                            Color.clear
                                .frame(height: scaledValue(DesignConstants.CoinsScreen.Sizes.lineThickness, for: geometry, isVertical: true))
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
                        .padding(.bottom, contentBottomPad)
                    
                    // Гибкий отступ для выталкивания контента вверх
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                MenuBarView(geometry: geometry, onDismiss: { navigationManager.popToRoot() })
                    .environmentObject(navigationManager)
            }
            .overlay(alignment: .bottom) {
                BottomBar.dual(
                    leftTitle: "СОХРАНИТЬ",
                    leftAction: { saveReading() },
                    rightTitle: "ВЫХОД В МЕНЮ",
                    rightAction: { navigationManager.popToRoot() },
                    lift: DesignConstants.Layout.ctaLiftSticky,
                    geometry: geometry,
                    textColor: .black
                )
                .padding(.bottom, DesignConstants.Layout.ctaSafeBottomPadding)
            }
        }
        .onAppear {
            // Обновляем гексограмму в overlay при появлении экрана
            navigationManager.updateHexagramLines(lines)
        }
    }
    
    // MARK: - Helper Functions
    
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
           value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding ||
           value == 40 {
            if isVertical {
                scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
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
    
    private func saveReading() {
        // Вычисляем вторую гексаграмму, если есть меняющиеся линии
        let hasChangingLines = lines.contains { $0.isChanging }
        let secondHexagram = hasChangingLines ? Hexagram.findSecond(byLines: lines) : nil
        
        let reading = Reading(
            date: Date(),
            question: question,
            hexagram: hexagram,
            lines: lines,
            secondHexagram: secondHexagram
        )
        StorageService.shared.saveReading(reading)
        
        // Простая обратная связь
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navigationManager.popToRoot()
        }
    }
}
