import SwiftUI
import UIKit

/// UIKit-backed label for guaranteed text rendering
struct UIKitLabel: UIViewRepresentable {
    var text: String
    var font: UIFont
    var color: UIColor
    var minimumScaleFactor: CGFloat = 0.85
    var textAlignment: NSTextAlignment = .left

    func makeUIView(context: Context) -> UILabel {
        let l = UILabel()
        l.numberOfLines = 1
        l.textAlignment = textAlignment
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = minimumScaleFactor
        l.lineBreakMode = .byTruncatingTail
        // ИСПРАВЛЕНИЕ: Устанавливаем правильные приоритеты для предотвращения коллапса и переполнения
        l.setContentCompressionResistancePriority(.required, for: .vertical)
        l.setContentHuggingPriority(.required, for: .vertical)
        // Horizontal: allow compression to fit, but prevent collapse to zero
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        l.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        #if DEBUG
        print("UIKitLabel makeUIView: text=\(text), font=\(font), color=\(color)")
        print("UIKitLabel makeUIView: intrinsicContentSize=\(l.intrinsicContentSize)")
        #endif
        
        return l
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.font = font
        uiView.textColor = color
        uiView.minimumScaleFactor = minimumScaleFactor
        uiView.textAlignment = textAlignment
        
        // ИСПРАВЛЕНИЕ: Обновляем layout без принудительного расширения
        uiView.setNeedsLayout()
        
        #if DEBUG
        print("UIKitLabel updateUIView: text=\(text), font=\(font), color=\(color)")
        print("UIKitLabel updateUIView: intrinsicContentSize=\(uiView.intrinsicContentSize), frame=\(uiView.frame)")
        print("UIKitLabel updateUIView: textColor=\(uiView.textColor?.description ?? "nil"), alpha=\(uiView.alpha)")
        #endif
    }
}

/// Reusable bottom CTA bar component that ensures consistent positioning across screens
struct BottomBar {
    // MARK: - Constants
    // Single source of truth for BottomBar spacing. Do not add extra horizontal padding in parent views.
    private static let edgeInsetBase: CGFloat = 48
    private static let minimumScaleFactor: CGFloat = 0.85
    
    // MARK: - Layout Functions
    
    /// Single button layout (primary CTA)
    static func primary(
        title: String,
        isDisabled: Bool = false,
        action: @escaping () -> Void,
        lift: CGFloat,
        geometry: GeometryProxy,
        textColor: Color = DesignConstants.CoinsScreen.Colors.buttonTextColor
    ) -> some View {
        let buttonHeight = scaledValue(DesignConstants.CoinsScreen.Sizes.buttonHeight, for: geometry, isVertical: true)
        let button = Button(action: action) {
            Text(title)
                .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                .foregroundColor(textColor)
                .padding(.horizontal, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonHorizontalPadding, for: geometry))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .disabled(isDisabled)
        .frame(maxWidth: .infinity)
        .frame(height: buttonHeight)
        
        return VStack(spacing: 0) {
            button
            Spacer()
                .frame(height: scaledValue(lift, for: geometry, isVertical: true))
        }
    }
    
    /// Dual button layout (two buttons side by side)
    static func dual(
        leftTitle: String,
        leftIsDisabled: Bool = false,
        leftAction: @escaping () -> Void,
        rightTitle: String,
        rightIsDisabled: Bool = false,
        rightAction: @escaping () -> Void,
        lift: CGFloat,
        geometry: GeometryProxy,
        textColor: Color = DesignConstants.CoinsScreen.Colors.buttonTextColor
    ) -> some View {
        // Compute font size
        let fs = scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)
        
        // Get UIFont and UIColor for UIKitLabel
        let uiFont = robotoMonoLightUIFont(size: fs)
        let uiColor = DesignConstants.Layout.ctaTextUIColor
        
        // FIXED: 48pt from screen edge to button text on both sides (symmetric)
        let horizontalPadding = scaledValue(Self.edgeInsetBase, for: geometry)
        
        let leftButtonHeight = scaledValue(DesignConstants.CoinsScreen.Sizes.buttonHeight, for: geometry, isVertical: true)
        
        // LEFT button label content - no fixedSize to allow shrinking
        let leftLabelContent = UIKitLabel(text: leftTitle, font: uiFont, color: uiColor, minimumScaleFactor: Self.minimumScaleFactor)
            .lineLimit(1)
        
        // LEFT tappable area
        let leftButton = leftLabelContent
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .frame(height: leftButtonHeight)
            .contentShape(Rectangle())
            .opacity(leftIsDisabled ? 0.4 : 1.0)
            .onTapGesture {
                if !leftIsDisabled {
                    leftAction()
                }
            }
        
        let rightButtonHeight = scaledValue(DesignConstants.CoinsScreen.Sizes.buttonHeight, for: geometry, isVertical: true)
        
        // RIGHT button label content - right-aligned text
        let rightLabelContent = UIKitLabel(text: rightTitle, font: uiFont, color: uiColor, minimumScaleFactor: Self.minimumScaleFactor, textAlignment: .right)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .trailing)
        
        // RIGHT tappable area - NO horizontal padding, NO leading alignment
        let rightButton = rightLabelContent
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .frame(height: rightButtonHeight)
            .contentShape(Rectangle())
            .opacity(rightIsDisabled ? 0.4 : 1.0)
            .onTapGesture {
                if !rightIsDisabled {
                    rightAction()
                }
            }
        
        // Deterministic layout: two explicit columns with trailing/leading alignment
        let buttons = HStack(spacing: 0) {
            leftButton
                .frame(maxWidth: .infinity, alignment: .leading)
            
            rightButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
        
        return VStack(spacing: 0) {
            buttons
            Spacer()
                .frame(height: scaledValue(lift, for: geometry, isVertical: true))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    /// Для горизонтальных значений использует ширину, для вертикальных - высоту
    private static func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
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
    /// Использует фиксированные размеры экрана, чтобы шрифты не менялись при появлении клавиатуры
    private static func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let widthScaleFactor = screenSize.width / DesignConstants.CoinsScreen.baseScreenWidth
        let heightScaleFactor = screenSize.height / DesignConstants.CoinsScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
    
    /// Создает шрифт Roboto Mono Light
    private static func robotoMonoLightFont(size: CGFloat) -> Font {
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
    
    /// Создает UIFont Roboto Mono Light для UIKitLabel
    private static func robotoMonoLightUIFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "RobotoMono-Light", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
}

