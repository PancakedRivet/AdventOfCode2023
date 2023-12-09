import Algorithms
import Foundation

struct Day09: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    func part1() -> Any {
        
        let DEBUG = false
        
        var extrapolationSum = 0
        
        for line in entities {
            
            if DEBUG {
                print("Line:", line)
            }
            
            var lineSplit = line.split(separator: " ").map { Int($0)! }
            let differenceList = determineDifference(lineSplit: lineSplit, DEBUG: DEBUG)
            
            let nextDiffValue = differenceList.last!
            let extrapolatedValue = lineSplit.last! + nextDiffValue
            lineSplit.append(extrapolatedValue)
            if DEBUG {
                print("Next Difference:", nextDiffValue, "Extrapolation:", extrapolatedValue, "Line:", lineSplit)
                print()
            }
            extrapolationSum += extrapolatedValue
        }
        
        return extrapolationSum
        // 1921197374 is too high
    }
    
    func determineDifference(lineSplit: [Int], depth: Int = 0, DEBUG: Bool) -> [Int] {
        
        var differenceList: [Int] = []
        
        for idx in 1..<lineSplit.count {
            let currentNum = lineSplit[idx]
            let prevNum = lineSplit[idx - 1]
            differenceList.append(currentNum - prevNum)
        }
        
        if DEBUG {
            print("A-Depth:", depth, "List:", differenceList)
        }
        
        var newDifferenceList: [Int] = differenceList
        
        if differenceList.reduce(0, +) != 0 {
            newDifferenceList = determineDifference(lineSplit: differenceList, depth: depth + 1, DEBUG: DEBUG)
            differenceList.append(newDifferenceList.last! + differenceList.last!)
        } else {
            if DEBUG {
                print("-Max depth:", depth)
            }
        }
        
        if DEBUG {
            print("B-Depth:", depth, "List:", differenceList)
        }
        
        return differenceList
    }
}
