import SwiftUI

struct CoinsView: View {
    let question: String?
    @State private var currentThrow: Int = 0
    @State private var lines: [Line] = []
    @State private var coins: [Bool] = [false, false, false]
    @State private var showHexagram = false
    
    private let totalThrows = 6
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                if currentThrow < totalThrows {
                    HStack(spacing: 20) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(coins[index] ? Color.black : Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                        }
                    }
                    .onTapGesture {
                        throwCoins()
                    }
                    
                    Text("Бросок \(currentThrow + 1) из \(totalThrows)")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.gray)
                } else {
                    VStack(spacing: 20) {
                        ForEach(Array(lines.reversed()), id: \.id) { line in
                            LineView(line: line)
                        }
                    }
                    .padding(.vertical, 40)
                    
                    Button(action: {
                        showHexagram = true
                    }) {
                        Text("Продолжить")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .padding(.bottom, 60)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showHexagram) {
            if let hexagram = Hexagram.find(byLines: lines) {
                HexagramView(hexagram: hexagram, lines: lines, question: question)
            } else {
                // Fallback на первую гексаграмму, если не найдена
                let fallback = Hexagram.loadAll().first ?? Hexagram(id: 1, number: 1, name: "Творчество", interpretation: "Сила и активность", character: "乾")
                HexagramView(hexagram: fallback, lines: lines, question: question)
            }
        }
    }
    
    private func throwCoins() {
        // Бросаем 3 монеты
        coins = (0..<3).map { _ in Bool.random() }
        
        // Подсчитываем результат: true = орёл (3), false = решка (2)
        // Старая система: 3 орла = 9 (старый ян), 2 орла 1 решка = 7 (ян)
        // 2 решки 1 орёл = 8 (инь), 3 решки = 6 (старый инь)
        let heads = coins.filter { $0 }.count
        
        let isYang: Bool
        let isChanging: Bool
        
        switch heads {
        case 3: // 3 орла
            isYang = true
            isChanging = true
        case 2: // 2 орла, 1 решка
            isYang = true
            isChanging = false
        case 1: // 1 орёл, 2 решки
            isYang = false
            isChanging = false
        default: // 0 орлов, 3 решки
            isYang = false
            isChanging = true
        }
        
        let line = Line(
            isYang: isYang,
            isChanging: isChanging,
            position: currentThrow + 1
        )
        
        lines.append(line)
        currentThrow += 1
    }
}

struct LineView: View {
    let line: Line
    
    var body: some View {
        Group {
            if line.isYang {
                Rectangle()
                    .fill(line.isChanging ? Color.orange.opacity(0.3) : Color.black)
                    .frame(width: 120, height: 4)
            } else {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(line.isChanging ? Color.orange.opacity(0.3) : Color.black)
                        .frame(width: 50, height: 4)
                    Rectangle()
                        .fill(line.isChanging ? Color.orange.opacity(0.3) : Color.black)
                        .frame(width: 50, height: 4)
                }
            }
        }
    }
}

