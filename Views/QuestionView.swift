import SwiftUI

struct QuestionView: View {
    @State private var question: String = ""
    @State private var showCoins = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("Сформулируй вопрос")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.black)
                
                TextField("", text: $question, axis: .vertical)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .lineLimit(3...6)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 30) {
                    Button(action: {
                        showCoins = true
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
                    
                    Button(action: {
                        showCoins = true
                    }) {
                        Text("Пропустить")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showCoins) {
            CoinsView(question: question.isEmpty ? nil : question)
        }
    }
}


