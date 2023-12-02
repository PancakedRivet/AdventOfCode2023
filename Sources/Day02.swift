import Algorithms
import Foundation

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    let conditions = ["red": 12, "green": 13, "blue": 14]

    func part1() -> Any {
        
        var gameIdSum = 0
        var gameId: Int
        var winningGame = true
        
        for line in entities {
            
            winningGame = true
            
            // Get the Game Id from the line
            let range = line.range(of: ":")!
            gameId = Int(line[line.index(line.startIndex, offsetBy: 5)..<range.lowerBound])!
            
//            print("Line:", line)
            
            // Break the remaining string into the seperate games for analysis
            let gameString = line[line.index(range.lowerBound, offsetBy: 1)...]
            let games = gameString.split(separator: ";")
            
            gameLoop: for game in games {
//                print("Game: ", game)
                
                // Break the games into the different coloured marble collections
                let marbleCollection = game.split(separator: ",")
                for marble in marbleCollection {
                    
                    // Split each part of the game into the value and colour
                    let marbleSplit = marble.split(separator: " ")
                    let numberOfMarbles = Int(marbleSplit[0])!
                    let marbleColour = String(marbleSplit[1])
                    if numberOfMarbles > conditions[marbleColour]! {
//                        print("Impossible game")
                        winningGame = false
                        break gameLoop
                    }
                }
            }
            if (winningGame) {
//                print("Winning game: ", gameId)
                gameIdSum += gameId
            }
        }
        return gameIdSum
    }
    
    func part2() -> Any {
        
        var gamePowerSum = 0
        
        var minMarbles = ["red": 0, "green": 0, "blue": 0]
        
        for line in entities {
            
            minMarbles = ["red": 0, "green": 0, "blue": 0]
            
            // Get the Game Id from the line
            let range = line.range(of: ":")!
            
//            print("Line:", line)
            
            // Break the remaining string into the seperate games for analysis
            let gameString = line[line.index(range.lowerBound, offsetBy: 1)...]
            let games = gameString.split(separator: ";")
            
            for game in games {
//                print("Game: ", game)
                
                // Break the games into the different coloured marble collections
                let marbleCollection = game.split(separator: ",")
                for marble in marbleCollection {
                    
                    let marbleSplit = marble.split(separator: " ")
                    let numberOfMarbles = Int(marbleSplit[0])!
                    let marbleColour = String(marbleSplit[1])

                    if minMarbles[marbleColour]! < numberOfMarbles {
                        minMarbles[marbleColour] = numberOfMarbles
                    }
                }
            }
            
            let gamePower = minMarbles["red"]! * minMarbles["green"]! * minMarbles["blue"]!
            gamePowerSum += gamePower
//            print("Marbles: ", minMarbles, " GamePower: ", gamePower)
            
        }
        return gamePowerSum
    }
    
    
}
