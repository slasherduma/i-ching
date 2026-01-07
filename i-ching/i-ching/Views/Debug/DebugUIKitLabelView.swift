#if DEBUG
import SwiftUI

/// STEP 4: Isolated test screen for UIKitLabel (no BottomBar layout interference)
struct DebugUIKitLabelView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("SwiftUI Text baseline")
                .foregroundColor(.red)

            UIKitLabel(text: "UIKitLabel baseline", font: UIFont.systemFont(ofSize: 18), color: UIColor.red)
                .frame(height: 40)
                .background(Color.yellow.opacity(0.3))
                .overlay(Rectangle().stroke(Color.red, lineWidth: 1))

            UIKitLabel(text: "UIKitLabel blue", font: UIFont.systemFont(ofSize: 18), color: UIColor.blue)
                .frame(height: 40)
                .background(Color.yellow.opacity(0.3))
                .overlay(Rectangle().stroke(Color.blue, lineWidth: 1))
            
            // Test with actual BottomBar font and color
            UIKitLabel(
                text: "UIKitLabel BottomBar style",
                font: UIFont.systemFont(ofSize: 18, weight: .light),
                color: UIColor(red: 255/255, green: 54/255, blue: 54/255, alpha: 1)
            )
                .frame(height: 40)
                .background(Color.yellow.opacity(0.3))
                .overlay(Rectangle().stroke(Color.green, lineWidth: 1))
        }
        .padding()
        .background(Color.black.opacity(0.05))
    }
}
#endif

