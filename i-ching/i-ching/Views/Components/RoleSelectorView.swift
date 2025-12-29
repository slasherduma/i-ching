import SwiftUI

enum UserRole: String, CaseIterable {
    case leader = "Я лидер"
    case subordinate = "Я участник"
    
    var shortName: String {
        switch self {
        case .leader:
            return "Лидер"
        case .subordinate:
            return "Участник"
        }
    }
}

struct RoleSelectorView: View {
    @Binding var selectedRole: UserRole
    let geometry: GeometryProxy?
    
    init(selectedRole: Binding<UserRole>, geometry: GeometryProxy? = nil) {
        self._selectedRole = selectedRole
        self.geometry = geometry
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Заголовок "Выбери свою роль" - Roboto Mono Thin 22pt
            Text("Выбери свою роль")
                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.InterpretationScreen.Typography.labelSize, for: geometry)))
                .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.roleSelectorHeaderBottom, for: geometry, isVertical: true))
            
            // Кнопки выбора роли
            HStack(alignment: .center, spacing: scaledValue(DesignConstants.InterpretationScreen.Spacing.roleButtonsSpacing, for: geometry, isVertical: false)) {
                ForEach(UserRole.allCases, id: \.self) { role in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRole = role
                        }
                    }) {
                        Text(role.shortName)
                            .font(helveticaNeueLightFont(size: scaledFontSize(36, for: geometry)))
                            .foregroundColor(DesignConstants.InterpretationScreen.Colors.textBlue)
                            .opacity(selectedRole == role ? 1.0 : 0.5)
                    }
                }
            }
            .padding(.bottom, scaledValue(DesignConstants.InterpretationScreen.Spacing.roleButtonsBottom, for: geometry, isVertical: true))
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
