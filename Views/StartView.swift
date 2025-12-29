import SwiftUI

struct StartView: View {
    @State private var opacity: Double = 0.3
    @State private var showNext = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Книга перемен")
                    .font(.system(size: 24, weight: .ultraLight, design: .default))
                    .foregroundColor(.black)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                opacity = 0.6
            }
        }
        .onTapGesture {
            showNext = true
        }
        .fullScreenCover(isPresented: $showNext) {
            QuestionView()
        }
    }
}


