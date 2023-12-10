import Algorithms
import Foundation

enum MapDirection: String {
    case North
    case South
    case East
    case West
}

struct MapCoordinate {
    var row: Int
    var col: Int
}

struct PipePiece {
    var pipeChar: Character
    var coordinates: MapCoordinate
    var headingOfNextPipe: MapDirection
}

struct Day10: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func part1() -> Any {
        
        let DEBUG = true
        
        var startingPoint: PipePiece = createStartingPointPipePiece()!
        
        startingPoint.headingOfNextPipe = getNextPipePieceDirection(coordinates: startingPoint.coordinates, DEBUG: DEBUG)!
        
        if DEBUG {
            print("Starting point:", startingPoint)
        }
    
        var loopIteration = 0
        
        var previousPipePiece: PipePiece = startingPoint
        
        while true {
            
            if DEBUG {
                print("Loop iter:", loopIteration)
                print("Prev:", previousPipePiece)
            }
            // Each pipe piece that we add to the array is checked for validity so we can just follow the pipe
            let nextPipeDirection = previousPipePiece.headingOfNextPipe
            
            let nextCoordinates = getNextCoordinatesInDirection(coordinates: previousPipePiece.coordinates, pipeHeading: nextPipeDirection)
            
            let nextPipeChar = getPipeChar(coordinates: nextCoordinates)
            
            if nextPipeChar == "S" {
                break
            }
            
            // This should always be true
            if !isPipeCharValid(pipeChar: nextPipeChar, intoDirection: nextPipeDirection) {
                print("Error occurred finding next pipe piece")
                break
            }
                
            let nextHeadingForNextPipe = getNextMapDirectionForChar(pipeChar: nextPipeChar, nextPipeDirection: nextPipeDirection)!
                    
            let nextPipePiece = PipePiece(pipeChar: nextPipeChar, coordinates: nextCoordinates, headingOfNextPipe: nextHeadingForNextPipe)
                
            if DEBUG {
                print("Next:", nextPipePiece)
                print()
            }
            
            previousPipePiece = nextPipePiece
            
            loopIteration += 1
            if loopIteration % 100 == 0 {
                print("Loop Iteration:", loopIteration)
            }
            
        }
        
        // The next iteration will return to the starting point, so the furthest disatnce away is half the size of the list
        
        return (loopIteration + 1) / 2
    }
    
    func createStartingPointPipePiece() -> Optional<PipePiece > {
        
        for (idx, line) in entities.enumerated() {
           
//            print("Line:", line)
            
            // Find the starting point
            let startingPointIndex = line.firstIndex(of: "S")
            if startingPointIndex != nil {
                
                let index: Int = line.distance(from: line.startIndex, to: startingPointIndex!)
                
                let startingPointCoordinates = MapCoordinate(row: idx, col: index)
                
                let startingPointNextPipeHeading = getNextPipePieceDirection(coordinates: startingPointCoordinates, DEBUG: false)!
                
                let startingPoint = PipePiece(pipeChar: "S", coordinates: startingPointCoordinates, headingOfNextPipe: startingPointNextPipeHeading)
                
                return Optional(startingPoint)
            }
        }
        print("! Starting point not found!")
        return Optional.none
    }
    
    // Called when every direction needs to be tested (such as with starting point
    func getNextPipePieceDirection(coordinates: MapCoordinate, DEBUG: Bool) -> Optional<MapDirection> {
        
        var nextCoordinates: MapCoordinate
        
        // Test pipe in the WEST direction
        if (coordinates.col != 0) {
            
            nextCoordinates = MapCoordinate(row: coordinates.row, col: coordinates.col - 1)
            
            if getNextPipePieceInDirection(nextCoordinates: nextCoordinates, pipeHeading: MapDirection.West, DEBUG: DEBUG) != nil {
                return MapDirection.West
            }
        }
        
        // Test pipes in the EAST direction
        if (coordinates.col != entities[0].count) {
            
            nextCoordinates = MapCoordinate(row: coordinates.row, col: coordinates.col + 1)
            
            if getNextPipePieceInDirection(nextCoordinates: nextCoordinates, pipeHeading: MapDirection.East, DEBUG: DEBUG) != nil {
                return MapDirection.East
            }
        }
        
        // Test pipes in the NORTH direction
        if (coordinates.row != 0) {
            
            nextCoordinates = MapCoordinate(row: coordinates.row - 1, col: coordinates.col)
            
            if getNextPipePieceInDirection(nextCoordinates: nextCoordinates, pipeHeading: MapDirection.North, DEBUG: DEBUG) != nil {
                return MapDirection.North
            }
        }
        
        // Test pipes in the SOUTH direction
        if (coordinates.row != entities.count) {
            
            nextCoordinates = MapCoordinate(row: coordinates.row + 1, col: coordinates.col)
            
            if getNextPipePieceInDirection(nextCoordinates: nextCoordinates, pipeHeading: MapDirection.South, DEBUG: DEBUG) != nil {
                return MapDirection.South
            }
        }
        
        print("! No valid direction found for coordinates:", coordinates)
        return Optional.none
    }
    
    // If the direction is valid, return the pipe piece in that direction
    func getNextPipePieceInDirection(nextCoordinates: MapCoordinate, pipeHeading: MapDirection, DEBUG: Bool) -> Optional<PipePiece> {
        
        let nextChar = getPipeChar(coordinates: nextCoordinates)
        
        if let nextPipeDirection = getNextMapDirectionForChar(pipeChar: nextChar, nextPipeDirection: pipeHeading) {
            
            let nextPipePiece = PipePiece(pipeChar: nextChar, coordinates: nextCoordinates, headingOfNextPipe: getOppositeDirection(direction: pipeHeading))
            
            if DEBUG {
                print("NextChar", nextChar, "Pipe Heading:", pipeHeading, "Next Direction:", nextPipeDirection)
            }
            
            return Optional.some(nextPipePiece)
        }
        
        return Optional.none
    }
    
    func getPipeChar(coordinates: MapCoordinate) -> Character {
        
        let pipeCharRow = entities[coordinates.row]
        
        let index = entities[coordinates.row].index(entities[coordinates.row].startIndex, offsetBy: coordinates.col)
        
        let pipeChar = pipeCharRow[index]
        
//        print("Coords", coordinates, "Char:", pipeChar)
        
        return pipeChar
    }
    
    func getNextCoordinatesInDirection(coordinates: MapCoordinate, pipeHeading: MapDirection) -> MapCoordinate {
        switch pipeHeading {
        case MapDirection.North:
            return MapCoordinate(row: coordinates.row - 1, col: coordinates.col)
        case MapDirection.South:
            return MapCoordinate(row: coordinates.row + 1, col: coordinates.col)
        case MapDirection.East:
            return MapCoordinate(row: coordinates.row, col: coordinates.col + 1)
        case MapDirection.West:
            return MapCoordinate(row: coordinates.row, col: coordinates.col - 1)
        }
    }
    
    func isPipeCharValid(pipeChar: Character, intoDirection: MapDirection) -> Bool {
        
        switch (intoDirection, pipeChar) {
        
        // E.g. Going North, you can only continue if you get one of:
        // - "|", "7" or "F" characters.\
        // All other characters are invalid
            
            // North
        case (MapDirection.North, "|"):
            return true
        case (MapDirection.North, "7"):
            return true
        case (MapDirection.North, "F"):
            return true
            
            // South
        case (MapDirection.South, "|"):
            return true
        case (MapDirection.South, "L"):
            return true
        case (MapDirection.South, "J"):
            return true
            
            // East
        case (MapDirection.East, "-"):
            return true
        case (MapDirection.East, "J"):
            return true
        case (MapDirection.East, "7"):
            return true
            
            // West
        case (MapDirection.West, "-"):
            return true
        case (MapDirection.West, "L"):
            return true
        case (MapDirection.West, "F"):
            return true
            
            // Any other cases are for invalid pipes
            // Need to handle "S" case seperately
        default:
            return false
        }
    }
    
    func getOppositeDirection(direction: MapDirection) -> MapDirection {
        // Used to attach the opposite direction based on from and to directions for PipePiece instances
        switch direction {
        case MapDirection.North:
            return MapDirection.South
        case MapDirection.South:
            return MapDirection.North
        case MapDirection.East:
            return MapDirection.West
        case MapDirection.West:
            return MapDirection.East
        }
    }
    
    func getNextMapDirectionForChar(pipeChar: Character, nextPipeDirection: MapDirection) -> Optional<MapDirection> {
        
        // E.g. "J" If you're travelling TO the East then you are coming FROM the West so you must go North
        
        switch (nextPipeDirection, pipeChar) {
        
            // North cases
        case (MapDirection.North, "|"), (MapDirection.West, "L"), (MapDirection.East, "J"):
            return Optional.some(MapDirection.North)
            
            // South cases
        case (MapDirection.South, "|"), (MapDirection.West, "F"), (MapDirection.East, "7"):
            return Optional.some(MapDirection.South)
            
            // East cases
        case (MapDirection.East, "-"), (MapDirection.South, "L"), (MapDirection.North, "F"):
            return Optional.some(MapDirection.East)
            
            // West cases
        case (MapDirection.West, "-"), (MapDirection.South, "J"), (MapDirection.North, "7"):
            return Optional.some(MapDirection.West)
            
        case (let direction, "S"):
            return Optional.some(direction)
            
        default:
            return Optional.none
        }
    }
    
}
