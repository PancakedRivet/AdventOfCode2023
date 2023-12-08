import Algorithms
import Foundation

struct MapEntry {
    var destinationRangeStart: Int
    var sourceRangeStart: Int
    var rangeLength: Int
}

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func part1() -> Any {
        
        let DEBUG = false
        
        var lowestLocationNumber: Int = 0
        
        let seedList = entities[0].split(separator: " ").dropFirst(1).map { Int($0)! }
        
        if DEBUG {
            print("Seeds:", seedList)
        }
        
        var mapList: [String: [MapEntry]] = [:]
        var mapName = ""
        
        var mapEntryList: [String] = []
        
        // Build all of the maps being used from the input lines
        for line in entities[1...] {
            if line.contains("map:") {
                mapName = String(line.split(separator: " ")[0])
                mapList[mapName] = []
                mapEntryList.append(mapName)
            } else {
                let lineSplit = line.split(separator: " ")
                let mapEntry: MapEntry = MapEntry(destinationRangeStart: Int(lineSplit[0])!, sourceRangeStart: Int(lineSplit[1])!,  rangeLength: Int(lineSplit[2])!)
                mapList[mapName]?.append(mapEntry)
            }
        }
        
        var newSeedList: [Int] = []
        
        for seedValue in seedList {
            var newSeedValue = seedValue
            for mapName in mapEntryList {
                let mappedSeedValue = performMap(mapSet: mapList[mapName]!, seed: newSeedValue)
                if DEBUG {
                    print("Map:", mapName, "Old:", newSeedValue, "New:", mappedSeedValue)
                }
                newSeedValue = mappedSeedValue
            }
            newSeedList.append(newSeedValue)
        }
        lowestLocationNumber = newSeedList.min()!
        return lowestLocationNumber
    }
    
    func part2() -> Any {
        
        let DEBUG = false
        
        var lowestLocationNumber: Int = 0
        
        let seedLine = entities[0].split(separator: " ").dropFirst(1).map { Int($0)! }
        
        var mapList: [String: [MapEntry]] = [:]
        var mapName = ""
        
        var mapEntryList: [String] = []
        
        // Build all of the maps being used from the input lines
        for line in entities[1...] {
            if line.contains("map:") {
                mapName = String(line.split(separator: " ")[0])
                mapList[mapName] = []
                mapEntryList.append(mapName)
            } else {
                let lineSplit = line.split(separator: " ")
                let mapEntry: MapEntry = MapEntry(destinationRangeStart: Int(lineSplit[0])!, sourceRangeStart: Int(lineSplit[1])!,  rangeLength: Int(lineSplit[2])!)
                mapList[mapName]?.append(mapEntry)
            }
        }
        
        for idx in stride(from: 0, to: seedLine.count, by: 2) {
            let startingPoint = seedLine[idx]
            let range = seedLine[idx + 1]
            let endingPoint = startingPoint + range
            let seedList = stride(from: startingPoint, to: endingPoint, by: 1)
            
            print("Searching pair:", idx / 2, "out of", seedLine.count / 2, "Numbers to check:", endingPoint - startingPoint)

            var lowestNumberofGroup = 0
            for seedValue in seedList {
                var newSeedValue = seedValue
                for mapName in mapEntryList {
                    let mappedSeedValue = performMap(mapSet: mapList[mapName]!, seed: newSeedValue)
                    if DEBUG {
                        print("Map:", mapName, "Old:", newSeedValue, "New:", mappedSeedValue)
                    }
                    newSeedValue = mappedSeedValue
                }
                
                // Ensure that lowestLocationNumber gets set initially
                if lowestLocationNumber <= 0 {
                    lowestLocationNumber = newSeedValue
                }
                if newSeedValue < lowestLocationNumber {
                    lowestLocationNumber = newSeedValue
                }
                
                // Get the lowest number of the group for checking
                if lowestNumberofGroup <= 0 {
                    lowestNumberofGroup = newSeedValue
                }
                if newSeedValue < lowestNumberofGroup {
                    lowestNumberofGroup = newSeedValue
                }
            }
            print("Lowest: (group)", lowestNumberofGroup, "(total)", lowestLocationNumber)
        }
        return lowestLocationNumber
    }
    
    func performMap(mapSet: [MapEntry], seed: Int) -> Int {
        var newSeedValue = seed
        for mapLine in mapSet {
            if !(mapLine.sourceRangeStart <= seed && seed <= mapLine.sourceRangeStart + mapLine.rangeLength) {
                // The seed is outside the map bound so return the original value
                continue
            }
            let seedValueNormalised = seed - mapLine.sourceRangeStart
            newSeedValue = mapLine.destinationRangeStart + seedValueNormalised
            // Seed values can only work for one map so if we find the map,
            // we can skip trying the rest of the map lines
            break
        }
        return newSeedValue
    }
}
