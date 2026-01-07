import SwiftUI

/// Overlay для отображения гексограммы поверх всех экранов
/// Это гарантирует, что гексограмма не пересоздается при переходе между экранами
struct HexagramOverlay: View {
    let lines: [Line]
    let geometry: GeometryProxy
    
    var body: some View {
        // Гексаграмма - отдельный фрейм, зафиксирована сверху
        VStack {
            Spacer()
                .frame(height: scaledValue(DesignConstants.CoinsScreen.Spacing.topToHexagram, for: geometry, isVertical: true))
            
            if !lines.isEmpty {
                VStack(spacing: scaledValue(DesignConstants.CoinsScreen.Sizes.lineSpacing, for: geometry, isVertical: true)) {
                    ForEach(Array(lines.reversed()), id: \.id) { line in
                        LineView(line: line, geometry: geometry)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
        .allowsHitTesting(false)
    }
    
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
}


