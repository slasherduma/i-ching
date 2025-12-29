import SwiftUI

struct MoodIndicatorView: View {
    let mood: MoodLevel
    
    var body: some View {
        VStack(spacing: 13) { // Число Фибоначчи
            Text(mood.rawValue)
                .font(.system(size: 13, weight: .light)) // Число Фибоначчи
                .foregroundColor(.black)
            
            // Визуальный индикатор
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index < moodIndex ? Color.black : Color.gray.opacity(0.2))
                        .frame(width: 8, height: 8) // Число Фибоначчи
                }
            }
        }
    }
    
    private var moodIndex: Int {
        switch mood {
        case .cautious:
            return 1
        case .balanced:
            return 2
        case .opportunities:
            return 3
        }
    }
}

