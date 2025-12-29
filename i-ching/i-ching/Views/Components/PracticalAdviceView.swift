import SwiftUI

struct PracticalAdviceView: View {
    let advice: [String]
    let geometry: GeometryProxy?
    
    init(advice: [String], geometry: GeometryProxy? = nil) {
        self.advice = advice
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: scaledValue(DesignConstants.InterpretationScreen.Spacing.betweenParagraphs, for: geometry, isVertical: true)) {
            Text("Практические шаги")
                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                .padding(.leading, scaledValue(DesignConstants.InterpretationScreen.Spacing.horizontalPadding, for: geometry))
            
            ForEach(Array(advice.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: scaledValue(4, for: geometry, isVertical: false)) {
                    Text("\(index + 1).")
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                    
                    Text(item)
                        .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.bodySize, for: geometry)))
                        .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, index < advice.count - 1 ? scaledValue(8, for: geometry, isVertical: true) : 0)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        let fontNames = [
            "Roboto Mono",
            "RobotoMono",
            "RobotoMono-VariableFont_wght",
            "RobotoMono Variable",
            "Roboto Mono Variable",
            "Roboto Mono Thin",
            "RobotoMono-Thin",
            "RobotoMonoThin"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
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
