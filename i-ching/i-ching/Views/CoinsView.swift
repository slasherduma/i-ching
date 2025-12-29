import SwiftUI

struct CoinsView: View {
    let question: String?
    @State private var currentThrow: Int = 0
    @State private var lines: [Line] = []
    @State private var coins: [Bool] = [Bool.random(), Bool.random(), Bool.random()]
    @State private var showHexagram = false
    @State private var isThrowing = false
    
    private let totalThrows = 6
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон
                DesignConstants.CoinsScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                // Гексаграмма - отдельный фрейм, зафиксирована сверху
                VStack {
                    Spacer()
                        .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram, for: geometry, isVertical: true))
                    
                    VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                        ForEach(Array(lines.reversed()), id: \.id) { line in
                            LineView(line: line, geometry: geometry)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .allowsHitTesting(false)
                
                // Монеты и счетчик - отдельный фрейм, центрированы по вертикали
                if currentThrow < totalThrows {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        // Три круга с иероглифами и монетами
                        HStack(spacing: scaledValue(DesignConstants.CoinsScreen.Spacing.betweenCircles, for: geometry)) {
                            Spacer()
                            
                            // Первый круг - 乾
                            CircleWithCharacter(
                                character: "乾",
                                showCoin: true,
                                coin: coins[0],
                                isThrowing: isThrowing,
                                geometry: geometry
                            )
                            
                            // Второй круг - 坤 (центральный)
                            CircleWithCharacter(
                                character: "坤",
                                showCoin: true,
                                coin: coins[1],
                                isThrowing: isThrowing,
                                geometry: geometry
                            )
                            
                            // Третий круг - 坤
                            CircleWithCharacter(
                                character: "坤",
                                showCoin: true,
                                coin: coins[2],
                                isThrowing: isThrowing,
                                geometry: geometry
                            )
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Отступ от кругов до счетчика
                        Spacer()
                            .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.circlesToCounter, for: geometry, isVertical: true))
                        
                        // Счетчик "1/6"
                        Text("\(currentThrow + 1)/\(totalThrows)")
                            .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.counterTextSize, for: geometry)))
                            .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, scaledValue(DesignConstants.CoinsScreen.Spacing.counterHorizontalPadding, for: geometry))
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                
                // Кнопка "БРОСИТЬ МОНЕТЫ" внизу
                VStack {
                    Spacer()
                    
                    if currentThrow < totalThrows {
                        Button(action: {
                            throwCoins()
                        }) {
                            Text("БРОСИТЬ МОНЕТЫ")
                                .font(drukWideCyrMediumFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                                .foregroundColor(DesignConstants.CoinsScreen.Colors.buttonTextColor)
                                .padding(.horizontal, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonHorizontalPadding, for: geometry))
                                .padding(.vertical, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                        }
                        .disabled(isThrowing)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonToBottom, for: geometry, isVertical: true))
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showHexagram) {
            if let hexagram = Hexagram.find(byLines: lines) {
                HexagramView(hexagram: hexagram, lines: lines, question: question)
                    .transition(.opacity)
            } else {
                // Fallback на первую гексаграмму, если не найдена
                let fallback = Hexagram.loadAll().first!
                HexagramView(hexagram: fallback, lines: lines, question: question)
                    .transition(.opacity)
            }
        }
    }
    
    private func throwCoins() {
        guard !isThrowing else { return }
        isThrowing = true
        
        // Анимация броска
        withAnimation(.easeOut(duration: 0.3)) {
            coins = [false, false, false]
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Бросаем 3 монеты
            coins = (0..<3).map { _ in Bool.random() }
            
            // Подсчитываем результат: true = орёл (3), false = решка (2)
            // Старая система: 3 орла = 9 (старый ян), 2 орла 1 решка = 7 (ян)
            // 2 решки 1 орёл = 8 (инь), 3 решки = 6 (старый инь)
            let heads = coins.filter { $0 }.count
            
            let isYang: Bool
            let isChanging: Bool
            
            switch heads {
            case 3: // 3 орла
                isYang = true
                isChanging = true
            case 2: // 2 орла, 1 решка
                isYang = true
                isChanging = false
            case 1: // 1 орёл, 2 решки
                isYang = false
                isChanging = false
            default: // 0 орлов, 3 решки
                isYang = false
                isChanging = true
            }
            
            let line = Line(
                isYang: isYang,
                isChanging: isChanging,
                position: currentThrow + 1
            )
            
            // Добавляем линию с плавной анимацией появления
            withAnimation(.easeInOut(duration: 0.3)) {
                lines.append(line)
            }
            
            currentThrow += 1
            
            // Если это был последний бросок, автоматически переходим на экран гексаграммы
            if currentThrow >= totalThrows {
                // Ждём завершения анимации появления последней линии, затем показываем экран гексаграммы
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showHexagram = true
                }
            }
            
            isThrowing = false
        }
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует минимальный коэффициент для сохранения пропорций
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
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
    
    /// Создает шрифт Roboto Mono Thin
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "RobotoMono-VariableFont_wght",
            "Roboto Mono",
            "RobotoMono-Thin",
            "RobotoMono-Thin"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .thin)
    }
    
    /// Создает шрифт Shippori Mincho Light
    private func shipporiMinchoLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Shippori Mincho",
            "ShipporiMincho-Light",
            "ShipporiMinchoLight"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .light)
    }
}

// MARK: - Circle With Character View
struct CircleWithCharacter: View {
    let character: String
    let showCoin: Bool
    let coin: Bool
    let isThrowing: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Круг с обводкой (показываем только когда нет монеты)
            if !showCoin {
                Circle()
                    .stroke(DesignConstants.CoinsScreen.Colors.circleBorderColor, lineWidth: scaledBorderWidth())
                    .frame(width: scaledCircleDiameter(), height: scaledCircleDiameter())
            }
            
            // Монета (если показываем) - всегда центрирована
            if showCoin {
                CoinView(isHeads: coin, isThrowing: isThrowing, geometry: geometry)
                    .frame(width: scaledCircleDiameter(), height: scaledCircleDiameter())
            } else {
                // Иероглиф (если монеты нет)
                Text(character)
                    .font(shipporiMinchoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.chineseCharacterSize, for: geometry)))
                    .foregroundColor(DesignConstants.CoinsScreen.Colors.chineseCharacterColor)
            }
        }
        .frame(width: scaledCircleDiameter(), height: scaledCircleDiameter())
    }
    
    private func scaledCircleDiameter() -> CGFloat {
        let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        return DesignConstants.CoinsScreen.Sizes.circleDiameter * scaleFactor
    }
    
    private func scaledBorderWidth() -> CGFloat {
        let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        return DesignConstants.CoinsScreen.Sizes.circleBorderWidth * scaleFactor
    }
    
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
    
    private func shipporiMinchoLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Shippori Mincho",
            "ShipporiMincho-Light",
            "ShipporiMinchoLight"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .light)
    }
}

// MARK: - Line View
struct LineView: View {
    let line: Line
    let geometry: GeometryProxy?
    
    // Инициализатор с geometry (для CoinsView)
    init(line: Line, geometry: GeometryProxy) {
        self.line = line
        self.geometry = geometry
    }
    
    // Инициализатор без geometry (для обратной совместимости)
    init(line: Line) {
        self.line = line
        self.geometry = nil
    }
    
    var body: some View {
        Group {
            if line.isYang {
                // Целая линия (ян)
                Image("Line")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(lineColor())
                    .frame(width: lineLength(), height: lineThickness())
            } else {
                // Прерывистая линия (инь)
                Image("Line_s")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(lineColor())
                    .frame(width: lineLength(), height: lineThickness())
            }
        }
    }
    
    private func lineColor() -> Color {
        let baseColor = DesignConstants.CoinsScreen.Colors.lineColor
        if line.isChanging {
            // Светлые линии (меняющиеся) - 50% прозрачности
            return baseColor.opacity(0.5)
        } else {
            // Темные линии - 100% opacity
            return baseColor
        }
    }
    
    private func lineLength() -> CGFloat {
        if let geometry = geometry {
            let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            return DesignConstants.CoinsScreen.Sizes.lineLength * scaleFactor
        } else {
            // Фиксированный размер для обратной совместимости
            return 120
        }
    }
    
    private func lineThickness() -> CGFloat {
        if let geometry = geometry {
            let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
            return DesignConstants.CoinsScreen.Sizes.lineThickness * scaleFactor
        } else {
            // Фиксированный размер для обратной совместимости
            return 3
        }
    }
}
