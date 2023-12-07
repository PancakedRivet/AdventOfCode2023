import Algorithms
import Foundation

struct Day06: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func calculateDistance(timeHoldingButton: Int, total: Int) -> Int {
        let distance = timeHoldingButton * (total - timeHoldingButton)
        return distance
    }

    func part1() -> Any {
        
        let DEBUG = false
        
        var winsPerRace: [Int] = []
            
        // Extract card info
        let timeList = entities[0].split(separator: " ").dropFirst(1)
        let distanceList = entities[1].split(separator: " ").dropFirst(1)
        
        for raceIdx in timeList.indices {
            let raceTime = Int(timeList[raceIdx])!
            let raceDistance = Int(distanceList[raceIdx])!
            
            var prevDistance = 0
            var numberOfWins = 0
            
            if DEBUG {
                print("Time:", raceTime, "Distance:", raceDistance)
            }
            
            for timeTrial in 0...raceTime {
                let trialDistance = calculateDistance(timeHoldingButton: timeTrial, total: raceTime)
                
                if DEBUG {
                    print("Trial Distance:", trialDistance, "With Time:", timeTrial)
                }
                
                if trialDistance > raceDistance {
                    if DEBUG {
                        print("Record broken")
                    }
                    numberOfWins += 1
                }
                
                // If the previous calculation returned a distance shorter than the limit we're testing against,
                // no attempts in the rest of the series will exceed it so stop testing
                if prevDistance != 0 && prevDistance < raceDistance && trialDistance < prevDistance {
                    if DEBUG {
                        print("Exiting the trials early")
                    }
                    break
                }
                
                prevDistance = trialDistance
            }
            
            winsPerRace.append(numberOfWins)
            
        }
        let marginOfError = winsPerRace.reduce(1, *)
        return marginOfError
    }
    
    func part2() -> Any {
        
        let DEBUG = false
            
        // Extract card info
        let raceTime = Int(entities[0].split(separator: " ").dropFirst(1).joined())!
        let raceDistance = Int(entities[1].split(separator: " ").dropFirst(1).joined())!
        
        if DEBUG {
            print("Time:", raceTime, "Distance:", raceDistance)
        }
            
        var prevDistance = 0
        var numberOfWins = 0
        
        for timeTrial in 0...raceTime {
            let trialDistance = calculateDistance(timeHoldingButton: timeTrial, total: raceTime)
            
            if DEBUG {
                print("Trial Distance:", trialDistance, "With Time:", timeTrial)
            }
            
            if trialDistance > raceDistance {
                if DEBUG {
                    print("Record broken")
                }
                numberOfWins += 1
            }
            
            // If the previous calculation returned a distance shorter than the limit we're testing against,
            // no attempts in the rest of the series will exceed it so stop testing
            if prevDistance != 0 && prevDistance < raceDistance && trialDistance < prevDistance {
                if DEBUG {
                    print("Exiting the trials early")
                }
                break
            }
            
            prevDistance = trialDistance
        }
        
        return numberOfWins
    }
    
}
