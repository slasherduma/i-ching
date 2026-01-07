import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    @Namespace private var hexagramNamespace
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Постоянный фон (остается всегда видимым)
                DesignConstants.StartScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                // Кастомная навигация с fade transitions
                ZStack {
                    // StartView (корневой экран)
                    if navigationManager.screens.isEmpty {
                        StartView()
                            .transition(.opacity)
                    } else if let currentScreen = navigationManager.currentScreen {
                        // Текущий экран из стека
                        currentScreen.view
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: navigationManager.screens.count)
                
                // MenuBarView поверх навигации (только когда не на StartView)
                if !navigationManager.screens.isEmpty {
                    MenuBarView(geometry: geometry)
                        .environmentObject(navigationManager)
                }
                
                // Гексограмма overlay - отображается только на экранах CoinsView и HexagramView
                // Это гарантирует, что гексограмма не пересоздается при переходе между экранами
                if !navigationManager.currentHexagramLines.isEmpty,
                   let currentScreen = navigationManager.currentScreen {
                    switch currentScreen {
                    case .coins, .hexagram:
                        HexagramOverlay(lines: navigationManager.currentHexagramLines, geometry: geometry)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .environmentObject(navigationManager)
        .environment(\.hexagramNamespace, hexagramNamespace)
    }
}

// Environment key для передачи namespace
private struct HexagramNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID = Namespace().wrappedValue
}

extension EnvironmentValues {
    var hexagramNamespace: Namespace.ID {
        get { self[HexagramNamespaceKey.self] }
        set { self[HexagramNamespaceKey.self] = newValue }
    }
}
