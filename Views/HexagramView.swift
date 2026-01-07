import SwiftUI

struct HexagramView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @State private var showInterpretation = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Гексаграмма
                VStack(spacing: 12) {
                    ForEach(Array(lines.reversed()), id: \.id) { line in
                        LineView(line: line)
                    }
                }
                .padding(.vertical, 30)
                
                // Номер и название
                VStack(spacing: 8) {
                    Text("\(hexagram.number)")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.black)
                    
                    Text(hexagram.name)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.black)
                }
                
                // Иероглиф
                Text(hexagram.character)
                    .font(.system(size: 80))
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    showInterpretation = true
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
        }
        .fullScreenCover(isPresented: $showInterpretation) {
            InterpretationView(hexagram: hexagram, lines: lines, question: question)
        }
    }
}


