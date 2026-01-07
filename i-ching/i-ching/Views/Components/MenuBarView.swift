import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu, for: geometry, isVertical: true) - geometry.safeAreaInsets.top)
            
            HStack {
                // Кнопка МЕНЮ слева
                Button(action: {
                    // Возвращаемся на стартовый экран через NavigationManager
                    navigationManager.popToRoot()
                }) {
                    Text("МЕНЮ")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                        .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                }
                .padding(.leading, scaledValue(DesignConstants.CoinsScreen.Spacing.menuHorizontalPadding, for: geometry))
                
                Spacer()
                
                // Иероглифы по центру
                Text("乾 坤")
                    .font(robotoMonoLightFont(size: scaledFontSize(36, for: geometry)))
                    .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                
                Spacer()
                
                // Кнопка ЗВУК справа (неактивна)
                Button(action: {
                    // Пока неактивна
                }) {
                    Text("ЗВУК")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                        .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                }
                .disabled(true)
                .padding(.trailing, scaledValue(DesignConstants.CoinsScreen.Spacing.menuHorizontalPadding, for: geometry))
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .allowsHitTesting(true)
    }
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально ширине экрана (для меню)
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        return size * scaleFactor
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
}

