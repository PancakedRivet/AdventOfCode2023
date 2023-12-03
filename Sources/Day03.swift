import Algorithms
import Foundation

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func calcPartNumberNew(line: String, symbolIdx: Int, isDebug: Bool = false) -> Int {
        
        var doSavePartNumber: Bool = false
        
        var partNumberSum: Int = 0
        var partNumber: String = ""
        
        for (lineIdx, lineChar) in line.enumerated() {
            
            // Skip past the characters that aren't numbers
            if !(lineChar.isASCII && lineChar.isNumber) {
                if partNumber.count > 0 {
                    if doSavePartNumber {
                        partNumberSum += Int(partNumber)!
                        if isDebug {
                            print("--PartNumber:", partNumber)
                        }
                    }
                }
                partNumber = ""
                doSavePartNumber = false
                continue
            }
            
            // lineIdx is the horizontal posisiton, so only keep numbers that are within 1 of lineIdx
            if abs(lineIdx - symbolIdx) <= 1 {
                doSavePartNumber = true
            }
            
            partNumber += String(lineChar)
            
        }
        
        // In case we exit the for loop by reaching the end of the line without adding partNumber
        if partNumber.count > 0 {
            if doSavePartNumber {
                partNumberSum += Int(partNumber)!
                if isDebug {
                    print("--PartNumber:", partNumber)
                }
            }
        }
        
        return partNumberSum
    }
    
    func part1() -> Any {
        
        let DEBUG = false
        
        var partNumberSum: Int = 0
        
        // Walk the line until we find a symbol
        for (idx, line) in entities.enumerated() {
            if DEBUG {
                print(idx, line)
            }
            // All characters in the data that are symbols
            let symbolCharacters = CharacterSet(charactersIn: "!@#$%^&*-+=/?")
            
            if CharacterSet(charactersIn: line).isDisjoint(with: symbolCharacters) {
                // If none of the characters in the line are symbols, move to the next line
                continue
            }
            
            // Determine where the symbol is
            for (lineIdx, char) in line.enumerated() {
                switch char {
                case "!", "@", "#", "$", "%", "^", "&", "*", "-", "+", "=", "/", "?":
                    break
                default:
                    continue
                }
                
                if DEBUG {
                    print("Symbol:", char)
                }
                
                // Check the same line left and right of the symbol
                if DEBUG {
                    print("-Checking same line")
                }
                let prevLinePartNumber = calcPartNumberNew(line: line, symbolIdx: lineIdx, isDebug: DEBUG)
                partNumberSum += prevLinePartNumber
                
                // Check the line above the symbol if we aren't on the first line
                if (idx > 0) {
                    if DEBUG {
                        print("-Checking previous line")
                    }
                    let prevLine = entities[idx - 1]
                    let prevLinePartNumber = calcPartNumberNew(line: prevLine, symbolIdx: lineIdx, isDebug: DEBUG)
                    partNumberSum += prevLinePartNumber
                }
                
                // Check the line below the symbol if we aren't on the first line
                if (idx + 1 < entities.count) {
                    if DEBUG {
                        print("-Checking next line")
                    }
                    let nextLine = entities[idx + 1]
                    let nextLinePartNumber = calcPartNumberNew(line: nextLine, symbolIdx: lineIdx, isDebug: DEBUG)
                    partNumberSum += nextLinePartNumber
                }
                
            }
        }
        return partNumberSum
    }
    
    func part2() -> Any {
        return 0
    }
}
