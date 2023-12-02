import Algorithms
import Foundation

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    let conditions: [MarbleColour: Int] = [.red: 12, .green: 13, .blue: 14]
    
    enum MarbleColour: String {
        case red
        case green
        case blue
    }
    
    func part1() -> Any {
        
        var gameIdSum = 0
        var gameId: Int
        var winningGame = true
        
        for line in entities {
            
            winningGame = true
            
            // Get the Game Id from the line
            let range = line.firstIndex(of: ":")!
            gameId = line.dropFirst(5)[..<range].first!.wholeNumberValue!
            
            // print("Line:", line)
            
            // Break the remaining string into the seperate games for analysis
            let gameString = line[range...].dropFirst()
            let games = gameString.split(separator: ";")
            
        gameLoop: for game in games {
            // print("Game: ", game)
            
            // Break the games into the different coloured marble collections
            let marbleCollection = game.split(separator: ",")
            for marble in marbleCollection {
                
                // Split each part of the game into the value and colour
                let marbleSplit = marble.split(separator: " ")
                let numberOfMarbles = Int(marbleSplit[0])!
                let marbleColour = MarbleColour(rawValue: String(marbleSplit[1]))!
                if numberOfMarbles > conditions[marbleColour]! {
                    //                        print("Impossible game")
                    winningGame = false
                    break gameLoop
                }
            }
        }
            if winningGame {
                //                print("Winning game: ", gameId)
                gameIdSum += gameId
            }
        }
        return gameIdSum
    }
    
    func part2() -> Any {
        
        var gamePowerSum = 0
        
        var minMarbles: [MarbleColour: Int] = [:]
        
        for line in entities {
            
            minMarbles.removeAll()
            
            // Get the Game Id from the line
            let range = line.range(of: ":")!
            
            //            print("Line:", line)
            
            // Break the remaining string into the seperate games for analysis
            let gameString = line[line.index(range.lowerBound, offsetBy: 1)...]
            let games = gameString.split(separator: ";")
            
            for game in games {
                // print("Game: ", game)
                
                // Break the games into the different coloured marble collections
                let marbleCollection = game.split(separator: ",")
                for marble in marbleCollection {
                    
                    let marbleSplit = marble.split(separator: " ")
                    let numberOfMarbles = Int(marbleSplit[0])!
                    let marbleColour = MarbleColour(rawValue: String(marbleSplit[1]))!
                    
                    if minMarbles[marbleColour, default: 0] < numberOfMarbles {
                        minMarbles[marbleColour] = numberOfMarbles
                    }
                }
            }
            
            let gamePower = minMarbles.values.reduce(1, *)
            gamePowerSum += gamePower
            //            print("Marbles: ", minMarbles, " GamePower: ", gamePower)
            
        }
        return gamePowerSum
    }
}
