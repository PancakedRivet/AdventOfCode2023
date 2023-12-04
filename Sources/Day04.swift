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
            
            if commonNumbers.count > 0 {
                let scratchCardValue: Int = Int(pow(Double(2), Double(commonNumbers.count - 1)))
                
                if DEBUG {
                    print("Matches:", commonNumbers.count, "Numbers:", commonNumbers, "Value:", scratchCardValue)
                }
                
                scratchCardSum += scratchCardValue
            }
                
        }
        return scratchCardSum
    }
    
    func part2() -> Any {
        
        let DEBUG = false
        
        var scratchCardSum: Int = 0
        
        var scratchCardCount: [Int: Int] = [1: 1]
        
        // Walk the line until we find a symbol
        for (idx, line) in entities.enumerated() {
            
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
            
            let cardIdx = 1 + idx // Card 1 is the 0th line in the data
            
            // There is always one copy of the card, so add it to the dict if it's not already present
            if scratchCardCount[cardIdx, default: 0] == 0 {
                scratchCardCount.updateValue(1, forKey: cardIdx)
            }
            
            if commonNumbers.count > 0 {
                // If there are matching numbers, update how many copies of the next cards we have
                
                if DEBUG {
                    print("Matches:", commonNumbers.count, "Numbers:", commonNumbers)
                }
                
                for i in 1...commonNumbers.count {
                    let nextCardIdx = cardIdx + i
                    let oldValue = scratchCardCount[nextCardIdx, default: 1]
                    let newValue = oldValue + scratchCardCount[cardIdx, default: 1]
                    scratchCardCount.updateValue(newValue, forKey: nextCardIdx)
                    if DEBUG {
                        print("Update - Game", nextCardIdx, "Old:", oldValue, "New", newValue)
                    }
                }
            }
            
        }
        
        if DEBUG {
            print(scratchCardCount.sorted(by: <))
        }
        
        scratchCardSum = scratchCardCount.values.reduce(0, +)
        
        return scratchCardSum
    }
}
