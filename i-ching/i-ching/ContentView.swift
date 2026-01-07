import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager()
    
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
            }
        }
        .environmentObject(navigationManager)
    }
}
