import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var musicService: BackgroundMusicService
    let geometry: GeometryProxy
    var isDiaryMode: Bool = false
    var onDismiss: (() -> Void)? = nil
    var diaryTitleColor: Color? = nil
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu, for: geometry, isVertical: true) - geometry.safeAreaInsets.top)
            
            HStack {
                // Кнопка МЕНЮ слева
                Button(action: withButtonSound {
                    if let onDismiss = onDismiss {
                        // Если передан onDismiss (для fullScreenCover или sheet), используем его
                        onDismiss()
                    } else {
                        // Иначе возвращаемся на стартовый экран через NavigationManager
                        navigationManager.popToRoot()
                    }
                }) {
                    Text("МЕНЮ")
                        .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                        .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                }
                .padding(.leading, scaledValue(DesignConstants.CoinsScreen.Spacing.menuHorizontalPadding, for: geometry))
                
                Spacer()
                
                // Иероглифы по центру или заголовок дневника
                if isDiaryMode {
                    Text("МОЙ ДНЕВНИК")
                        .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                        .foregroundColor(diaryTitleColor ?? DesignConstants.CoinsScreen.Colors.counterTextColor)
                        .accessibilityLabel("Мой дневник")
                } else {
                    Text("乾 坤")
                        .font(robotoMonoLightFont(size: scaledFontSize(36, for: geometry)))
                        .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                }
                
                Spacer()
                
                // Кнопка ЗВУК справа
                Button(action: withButtonSound {
                    if musicService.isPlaying {
                        musicService.pause()
                    } else {
                        musicService.play()
                    }
                }) {
                    Text("ЗВУК")
                        .font(robotoMonoLightFont(size: scaledFontSize(22, for: geometry)))
                        .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                        .strikethrough(!musicService.isPlaying)
                }
                .padding(.trailing, scaledValue(DesignConstants.CoinsScreen.Spacing.menuHorizontalPadding, for: geometry))
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
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

