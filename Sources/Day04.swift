import Algorithms
import Foundation

struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func part1() -> Any {
        
        let DEBUG = false
        
        var scratchCardSum: Int = 0
        
        // Walk the line until we find a symbol
        for line in entities {
            
            // Extract card info
            let cardWinningNumbersStartIdx = line.firstIndex(of: ":")!
            let cardLotteryNumbersStartIdx = line.firstIndex(of: "|")!
            let winningNumbersList = line[cardWinningNumbersStartIdx..<cardLotteryNumbersStartIdx].dropFirst(2)
            
            let lotteryNumbersList = line[cardLotteryNumbersStartIdx...].dropFirst()
            
            if DEBUG {
                print("Line:", line, " Winning Numbers: ", winningNumbersList, "Lottery Numbers:", lotteryNumbersList)
            }
            
            let winningNumbers = winningNumbersList.split(separator: " ")
            let lotteryNumbers = lotteryNumbersList.split(separator: " ")
            
            let commonNumbers: Set<Substring> = Set(winningNumbers).intersection(lotteryNumbers)
            print(commonNumbers)
            
            if commonNumbers.count > 0 {
                let scratchCardValue: Int = Int(pow(Double(2), Double(commonNumbers.count - 1)))
                
                if DEBUG {
                    print("Matches:", commonNumbers.count, " Value:", scratchCardValue)
                }
                
                scratchCardSum += scratchCardValue
            }
                
        }
        return scratchCardSum
    }
}
