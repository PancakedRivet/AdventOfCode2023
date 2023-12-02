import Algorithms
import Foundation

extension String {
 func parseToInt() -> String {
     self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
 }
}

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    func part1() -> Any {
        var coordinateValue = 0
        var currentLineValue: String
        for line in entities {
            let numbersInLine = line.parseToInt()
            currentLineValue = String(numbersInLine.first!) + String(numbersInLine.last!)
            coordinateValue += Int(currentLineValue)!
        }
        return coordinateValue
    }
    
    func part2() -> Any {
            
        var coordinateValue = 0
        
        var currentLineValue: String
        var reversedLine: String
        
        var firstDigit: String
        var lastDigit: String
        
        for line in entities {
            
            // Reset the strings to empty on each line
            currentLineValue = ""
            firstDigit = "0"
            lastDigit = "0"
            
            // Search the line forwards
            for char in line {
                
                currentLineValue += String(char)
                
                if Int(String(char)) != nil {
                    firstDigit = String(char)
                    break
                }
                
                if let stringNumber = checkIfNumberString(lineString: currentLineValue) {
                    firstDigit = stringNumber
                    break
                }
                
            }
            
            // Search the line backwards
            currentLineValue = ""
            reversedLine = String(line.reversed())
            for char in reversedLine {
                
                currentLineValue += String(char)
                
                if Int(String(char)) != nil {
                    lastDigit = String(char)
                    break
                }
                
                if let stringNumber = checkIfNumberString(lineString: String(currentLineValue.reversed())) {
                    lastDigit = stringNumber
                    break
                }
                
            }
            
            currentLineValue = firstDigit + lastDigit
            coordinateValue += Int(currentLineValue)!
        }
        return coordinateValue
    }
    
    func checkIfNumberString(lineString: String) -> Optional<String> {
        if lineString.contains("one") {
            return "1"
        } else if lineString.contains("two") {
            return "2"
        } else if lineString.contains("three") {
            return "3"
        } else if lineString.contains("four") {
            return "4"
        } else if lineString.contains("five") {
            return "5"
        } else if lineString.contains("six") {
            return "6"
        } else if lineString.contains("seven") {
            return "7"
        } else if lineString.contains("eight") {
            return "8"
        } else if lineString.contains("nine") {
            return "9"
        }
        
        return nil
    }
}
