import Algorithms
import Foundation

extension String {
    fileprivate func parseToInt() -> String {
        self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [Substring] {
        data.split(whereSeparator: { $0.isNewline })
    }
    
    func part1() -> Any {
        var coordinateValue = 0
        for line in entities {
            let numbersInLine = line.lazy.compactMap { $0.wholeNumberValue }
            coordinateValue += 10 * numbersInLine.first! + numbersInLine.last!
        }
        return coordinateValue
    }
    
    func part2() -> Any {
        
        var coordinateValue = 0
        
        for line in entities {
            
            var firstDigit: Int?
            var lastDigit: Int?
            
            // Search the line forwards
            for (i, char) in zip(line.indices, line) {
                if let number = char.wholeNumberValue {
                    firstDigit = number
                    break
                } else if let stringNumber = parseNumberString(lineString: line[i...]) {
                    firstDigit = stringNumber
                    break
                }
            }
            
            // Search the line backwards
            for (i, char) in zip(line.indices, line).reversed() {
                if let number = char.wholeNumberValue {
                    lastDigit = number
                    break
                } else if let stringNumber = parseNumberString(lineString: line[i...]) {
                    lastDigit = stringNumber
                    break
                }
            }
            
            if let firstDigit = firstDigit, let lastDigit = lastDigit {
                print("Found \(firstDigit), \(lastDigit)")
                coordinateValue += firstDigit * 10 + lastDigit
            }
        }
        return coordinateValue
    }
    
    func parseNumberString(lineString: some StringProtocol) -> Int? {
        return if lineString.hasPrefix("one") {
            1
        } else if lineString.hasPrefix("two") {
            2
        } else if lineString.hasPrefix("three") {
            3
        } else if lineString.hasPrefix("four") {
            4
        } else if lineString.hasPrefix("five") {
            5
        } else if lineString.hasPrefix("six") {
            6
        } else if lineString.hasPrefix("seven") {
            7
        } else if lineString.hasPrefix("eight") {
            8
        } else if lineString.hasPrefix("nine") {
            9
        } else {
            nil
        }
    }
}