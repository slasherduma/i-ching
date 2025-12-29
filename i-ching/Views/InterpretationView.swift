import SwiftUI

struct InterpretationView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @State private var showResult = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                ScrollView {
                    Text(hexagram.interpretation)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.black)
                        .lineSpacing(8)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                }
                
                Text("субтитры созданы Dima Torzok")
                    .font(.system(size: 12, weight: .ultraLight))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Button(action: {
                    showResult = true
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
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showResult) {
            ResultView(hexagram: hexagram, lines: lines, question: question)
        }
    }
}


