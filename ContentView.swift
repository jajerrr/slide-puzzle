import SwiftUI

struct Puzzle: View {
    let text: String
    let isEmpty: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(width: 80, height: 80)
                .foregroundColor(isEmpty ? .clear : .white)
                .background(isEmpty ? Color.clear : Color.pink)
                .cornerRadius(10)
        }
        
    }
}

struct ContentView: View {
    @State private var puzzleMatrix: [[String]] = [
        ["8", "5", "10", "9"],
        ["2", "6", "3", "7"],
        ["4", "1", "12", "13"],
        ["15", "11", "14", " "]
    ]
    @State private var won: Bool = false
    @State private var moves: Int = 0

    func onTap(row: Int, col: Int) {
        guard !won && puzzleMatrix[row][col] != " " else { return }
        let directions: [(Int, Int)] = [(0, -1), (0, 1), (-1, 0), (1, 0)]
        for (dx, dy) in directions {
            let newRow = row + dx
            let newCol = col + dy
            if newRow >= 0 && newRow < 4 && newCol >= 0 && newCol < 4 && puzzleMatrix[newRow][newCol] == " " {
                puzzleMatrix[newRow][newCol] = puzzleMatrix[row][col]
                puzzleMatrix[row][col] = " "
                moves += 1
                checkCompletion()
                break
            }
        }
    }

    func checkCompletion() {
        for row in 0..<4 {
            for col in 0..<4 {
                if puzzleMatrix[row][col] != "\(row * 4 + col + 1)" && puzzleMatrix[row][col] != " " {
                    return
                }
            }
        }
        won = true
    }

    func shuffleMatrix() {
        puzzleMatrix = puzzleMatrix.flatMap { $0 }.shuffled().chunked(into: 4)
        won = false
        moves = 0
    }

    var body: some View {
        
    
        VStack(spacing: 10) {
            Button(action: {
                shuffleMatrix()
            }) {
                Text("New Game")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
                    
                    
            }
        
            ForEach(0..<4, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<4, id: \.self) { col in
                        Puzzle(text: puzzleMatrix[row][col], isEmpty: puzzleMatrix[row][col] == " ", onTap: {
                            withAnimation {
                            onTap(row: row, col: col)}
                        })
                        .transition(.slide)
                    }
                }
            }
            if won {
                Text("You Won!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
            Text("Moves: \(moves)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding()

    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
