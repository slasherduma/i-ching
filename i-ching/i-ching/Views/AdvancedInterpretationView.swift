import SwiftUI

struct AdvancedInterpretationView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let secondHexagram: Hexagram?
    let geometry: GeometryProxy?
    
    init(hexagram: Hexagram, lines: [Line], secondHexagram: Hexagram?, geometry: GeometryProxy? = nil) {
        self.hexagram = hexagram
        self.lines = lines
        self.secondHexagram = secondHexagram
        self.geometry = geometry
    }
    
    private var changingLines: [Line] {
        lines.filter { $0.isChanging }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 34) { // Число Фибоначчи
            // Разделитель
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.vertical, 21) // Число Фибоначчи
            
            // Блок "Текст по каждой линии"
            if !changingLines.isEmpty, let lineTexts = hexagram.lineTexts, !lineTexts.isEmpty {
                VStack(alignment: .leading, spacing: 13) { // Число Фибоначчи
                    Text("Текст по меняющимся линиям")
                        .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                        .foregroundColor(.gray)
                    
                    ForEach(changingLines.sorted(by: { $0.position < $1.position }), id: \.id) { line in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                // Визуализация линии
                                if line.isYang {
                                    Rectangle()
                                        .fill(Color.orange.opacity(0.5))
                                        .frame(width: 55, height: 2) // Число Фибоначчи
                                } else {
                                    HStack(spacing: 5) {
                                        Rectangle()
                                            .fill(Color.orange.opacity(0.5))
                                            .frame(width: 21, height: 2) // Число Фибоначчи
                                        Rectangle()
                                            .fill(Color.orange.opacity(0.5))
                                            .frame(width: 21, height: 2) // Число Фибоначчи
                                    }
                                }
                                
                                Text("Линия \(line.position)")
                                    .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                                    .foregroundColor(.gray)
                            }
                            
                            // Текст линии
                            let position = line.position - 1 // Индекс массива (0-5)
                            if position >= 0 && position < lineTexts.count {
                                Text(lineTexts[position])
                                    .font(.system(size: 13, weight: .light)) // Число Фибоначчи
                                    .foregroundColor(.black)
                                    .lineSpacing(5)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            
            // Блок "Объяснение триграмм"
            if let trigrams = hexagram.trigrams {
                VStack(alignment: .leading, spacing: 13) { // Число Фибоначчи
                    Text("Объяснение триграмм")
                        .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                        .foregroundColor(.gray)
                    
                    // Верхняя триграмма (линии 4-6)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Верхняя триграмма")
                            .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                            .foregroundColor(.gray)
                        
                        // Визуализация триграммы
                        VStack(spacing: 5) {
                            ForEach([4, 5, 6], id: \.self) { pos in
                                if let line = lines.first(where: { $0.position == pos }) {
                                    if line.isYang {
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 34, height: 2) // Число Фибоначчи
                                    } else {
                                        HStack(spacing: 3) {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 13, height: 2) // Число Фибоначчи
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 13, height: 2) // Число Фибоначчи
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Text(trigrams.upper.name)
                            .font(.system(size: 13, weight: .light)) // Число Фибоначчи
                            .foregroundColor(.black)
                        
                        Text(trigrams.upper.description)
                            .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                    }
                    .padding(.bottom, 21) // Число Фибоначчи
                    
                    // Нижняя триграмма (линии 1-3)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Нижняя триграмма")
                            .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                            .foregroundColor(.gray)
                        
                        // Визуализация триграммы
                        VStack(spacing: 5) {
                            ForEach([1, 2, 3], id: \.self) { pos in
                                if let line = lines.first(where: { $0.position == pos }) {
                                    if line.isYang {
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 34, height: 2) // Число Фибоначчи
                                    } else {
                                        HStack(spacing: 3) {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 13, height: 2) // Число Фибоначчи
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 13, height: 2) // Число Фибоначчи
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Text(trigrams.lower.name)
                            .font(.system(size: 13, weight: .light)) // Число Фибоначчи
                            .foregroundColor(.black)
                        
                        Text(trigrams.lower.description)
                            .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                    }
                }
            }
            
            // Блок "Для размышления"
            if let questions = hexagram.reflectionQuestions, !questions.isEmpty {
                VStack(alignment: .leading, spacing: 13) { // Число Фибоначчи
                    Text("Для размышления")
                        .font(.system(size: 13, weight: .ultraLight)) // Число Фибоначчи
                        .foregroundColor(.gray)
                    
                    ForEach(questions, id: \.self) { question in
                        Text("• \(question)")
                            .font(.system(size: 13, weight: .light)) // Число Фибоначчи
                            .foregroundColor(.black)
                            .lineSpacing(5)
                            .padding(.bottom, 8)
                    }
                }
            }
        }
        .padding(.horizontal, 60)
        .padding(.bottom, 34) // Число Фибоначчи
    }
}

