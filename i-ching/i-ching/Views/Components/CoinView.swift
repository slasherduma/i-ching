import SwiftUI

struct CoinView: View {
    let isHeads: Bool
    let isThrowing: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        Group {
            if isHeads {
                Image("Coin 1")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(coinColor())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: scaledCoinDiameter(), height: scaledCoinDiameter())
            } else {
                Image("Coin 2")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(coinColor())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: scaledCoinDiameter(), height: scaledCoinDiameter())
            }
        }
    }
    
    private func coinColor() -> Color {
        if isThrowing {
            // Синий цвет с 50% прозрачности во время броска
            return DesignConstants.CoinsScreen.Colors.lineColor.opacity(0.5)
        } else {
            // Синий цвет в обычном состоянии
            return DesignConstants.CoinsScreen.Colors.lineColor
        }
    }
    
    private func scaledCoinDiameter() -> CGFloat {
        let scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        return DesignConstants.CoinsScreen.Sizes.coinDiameter * scaleFactor
    }
}
