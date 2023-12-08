import Algorithms
import Foundation

struct Direction {
    var left: String
    var right: String
}

struct Day08: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    func part1() -> Any {
        
        let DEBUG = false
        
        let directionList = entities[0].split(separator: "").map { String($0) }
        
        var directionMap: [String: Direction] = [:]
        
        // Create a dictionary of direction options
        for line in entities[1...] {

            let lineSplit = String(line).split(separator: "=")//.map { String($0) }
            let source = lineSplit[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let mapTo = lineSplit[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let directions = mapTo.dropFirst().dropLast().split(separator: ", ")
            
            let newDirectionOption = Direction(left: String(directions[0]), right: String(directions[1]))
            
            directionMap[source] = newDirectionOption
        }
        
        if DEBUG {
            print("Directions:", directionMap)
        }
        
        // Counter for the iteration inside of the while loop
        var stepCount = 0
        
        let startingPoint = "AAA"
        var currentPoint = startingPoint
        
        while currentPoint != "ZZZ" {
            
            let directionStep = stepCount % directionList.count
            
            // L or R in the list of directions
            let direction = directionList[directionStep]
            
            if direction == "L" {
                currentPoint = directionMap[currentPoint]!.left
            }
            else if direction == "R" {
                currentPoint = directionMap[currentPoint]!.right
            } else {
                print("DIRECTION UNKNOWN")
            }
            
            if DEBUG {
                print("Step:", stepCount, "New point:", currentPoint)
            }
            
            stepCount += 1
        }
        
        return stepCount
    }
    
    func part2() -> Any {
        // Note: This is a permutation problem, we don't need to keep calculating
        // until all starts are the same, we need to find the number of steps for
        // each starting point to reach each the ending point then multiply the
        // values together.
        
        let DEBUG = false
        
        let directionList = entities[0].split(separator: "").map { String($0) }
        
        var directionMap: [String: Direction] = [:]
        
        // Create a dictionary of direction options
        for line in entities[1...] {
            let lineSplit = String(line).split(separator: "=")//.map { String($0) }
            let source = lineSplit[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let mapTo = lineSplit[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            let directions = mapTo.dropFirst().dropLast().split(separator: ", ")
            
            let newDirectionOption = Direction(left: String(directions[0]), right: String(directions[1]))
            
            directionMap[source] = newDirectionOption
        }
        
        let cycleCount = directionList.count
        
        if DEBUG {
            print("Instruction Count:", cycleCount, "Direction Count:", directionMap.count)
        }
        
        let currentPointList = directionMap.keys.filter { $0.hasSuffix("A") }.map { String($0) }
        var stepsTakenList: [Int] = []
        
        if DEBUG {
            print("Starting Points:", currentPointList, "Count:", currentPointList.count)
        }
        
        for idx in 0..<currentPointList.count {
            
            var stepCount = 0
            var currentPoint = currentPointList[idx]
            
            while !currentPoint.hasSuffix("Z") {
                
                let directionStep = stepCount % directionList.count
                
                // L or R in the list of directions
                let direction = directionList[directionStep]
                
                if direction == "L" {
                    currentPoint = directionMap[currentPoint]!.left
                }
                else if direction == "R" {
                    currentPoint = directionMap[currentPoint]!.right
                } else {
                    print("DIRECTION UNKNOWN")
                }
                
//                if DEBUG {
//                    print("Step:", stepCount, "New point:", currentPoint)
//                }
                
                stepCount += 1
            }
            
            if DEBUG {
                print("Start:", currentPointList[idx], "End:", currentPoint, "Steps:", stepCount)
            }
            
            // Dividing by the number of cycles (I don't really understand why this works)
            stepsTakenList.append(stepCount / cycleCount)
        }
        
        if DEBUG {
            print("Steps Taken List:", stepsTakenList)
        }
        
        // Because we removed the cycle count earlier, we re-introduce the cycle count here (I think?)
        let totalStepsTaken = stepsTakenList.reduce(1, *) * cycleCount
        
        return totalStepsTaken
    }
}
