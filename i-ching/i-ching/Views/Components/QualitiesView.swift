import SwiftUI

struct QualitiesView: View {
    let qualities: [String]
    let geometry: GeometryProxy?
    
    init(qualities: [String], geometry: GeometryProxy? = nil) {
        self.qualities = qualities
        self.geometry = geometry
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: scaledValue(8, for: geometry, isVertical: false)) {
                ForEach(qualities, id: \.self) { quality in
                    Text(quality)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(13, for: geometry, isVertical: false))
                        .padding(.vertical, scaledValue(5, for: geometry, isVertical: true))
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(DesignConstants.InterpretationScreen.Colors.textBlue.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(DesignConstants.InterpretationScreen.Colors.textBlue.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
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
    
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy?, isVertical: Bool = false) -> CGFloat {
        guard let geometry = geometry else { return value }
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.InterpretationScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.InterpretationScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy?) -> CGFloat {
        guard let geometry = geometry else { return size }
        let widthScaleFactor = geometry.size.width / DesignConstants.InterpretationScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.InterpretationScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}
