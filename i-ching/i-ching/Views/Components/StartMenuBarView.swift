import SwiftUI

struct StartMenuBarView: View {
    @EnvironmentObject var musicService: BackgroundMusicService
    let geometry: GeometryProxy
    var customCenterText: String? = nil
    
    // Форматирование даты в формате dd/MM/yyyy (например, 08/01/2026)
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
    }
    
    // Текст по центру: кастомный или дата
    private var centerText: String {
        customCenterText ?? formattedDate
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToMenu, for: geometry, isVertical: true) - geometry.safeAreaInsets.top)
            
            HStack {
                // Кнопка ИНФО слева (неактивная)
                Text("ИНФО")
                    .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
                    .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                    .opacity(0.4)
                    .padding(.leading, scaledValue(DesignConstants.CoinsScreen.Spacing.menuHorizontalPadding, for: geometry))
                
                Spacer()
                
                // Текст по центру: кастомный или дата
                Text(centerText)
                    .font(robotoMonoLightFont(size: scaledFontSize(36, for: geometry)))
                    .foregroundColor(DesignConstants.CoinsScreen.Colors.counterTextColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                // Кнопка ЗВУК справа (такая же, как в MenuBarView)
                Button(action: withButtonSound {
                    if musicService.isPlaying {
                        musicService.pause()
                    } else {
                        musicService.play()
                    }
                }) {
                    Text("ЗВУК")
                        .font(robotoMonoLightFont(size: scaledFontSize(24, for: geometry)))
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
