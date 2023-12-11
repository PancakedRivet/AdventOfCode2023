import Algorithms
import Foundation

enum MapDirection: String {
    case north
    case south
    case east
    case west
    
    var opposite: MapDirection {
        // Used to attach the opposite direction based on from and to directions for PipePiece instances
        switch self {
        case .north:
            return .south
        case .south:
            return .north
        case .east:
            return .west
        case .west:
            return .east
        }
    }
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
    let data: String
    let entities: [[Character]]
    
    init(data: String) {
        self.data = data
        self.entities = data.split(whereSeparator: { $0.isNewline }).map { Array($0) }
    }
    
    func part1() -> Any {
        
        let DEBUG = false
        
        var startingPoint: PipePiece = createStartingPointPipePiece()!
        startingPoint.headingOfNextPipe = directionForNextPipePiece(startingAt: startingPoint.coordinates, debug: DEBUG)!
        
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
            
            let nextCoordinates = nextCoordinates(startingAt: previousPipePiece.coordinates, heading: nextPipeDirection)
            
            let nextPipeChar = pipeCharacter(at: nextCoordinates)
            
            if nextPipeChar == "S" {
                break
            }
            
            // This should always be true
            assert(isPipeCharValid(pipeChar: nextPipeChar, intoDirection: nextPipeDirection), "Error occurred finding next pipe piece")
                
            let nextHeadingForNextPipe = nextDirection(approaching: nextPipeChar, heading: nextPipeDirection)!
                    
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
    
    func createStartingPointPipePiece() -> PipePiece? {
        for (idx, line) in entities.enumerated() {
           
            // Find the starting point
            if let startingPointIndex = line.firstIndex(of: "S") {
                let index = line.distance(from: line.startIndex, to: startingPointIndex)
                
                let startingPointCoordinates = MapCoordinate(row: idx, col: index)
                
                let startingPointNextPipeHeading = directionForNextPipePiece(startingAt: startingPointCoordinates, debug: false)!
                
                let startingPoint = PipePiece(pipeChar: "S", coordinates: startingPointCoordinates, headingOfNextPipe: startingPointNextPipeHeading)
                
                return startingPoint
            }
        }
        print("! Starting point not found!")
        return nil
    }
    
    // Called when every direction needs to be tested (such as with starting point
    func directionForNextPipePiece(startingAt coordinates: MapCoordinate, debug DEBUG: Bool = false) -> Optional<MapDirection> {
        
        // Test pipe in the WEST direction
        if coordinates.col != 0 {
            let nextCoordinates = MapCoordinate(row: coordinates.row, col: coordinates.col - 1)
            
            if nextPipePiece(from: nextCoordinates, heading: .west, debug: DEBUG) != nil {
                return .west
            }
        }
        
        // Test pipes in the EAST direction
        if coordinates.col != entities[0].count {
            let nextCoordinates = MapCoordinate(row: coordinates.row, col: coordinates.col + 1)
            
            if nextPipePiece(from: nextCoordinates, heading: .east, debug: DEBUG) != nil {
                return .east
            }
        }
        
        // Test pipes in the NORTH direction
        if (coordinates.row != 0) {
            let nextCoordinates = MapCoordinate(row: coordinates.row - 1, col: coordinates.col)
            
            if nextPipePiece(from: nextCoordinates, heading: .north, debug: DEBUG) != nil {
                return .north
            }
        }
        
        // Test pipes in the SOUTH direction
        if (coordinates.row != entities.count) {
            let nextCoordinates = MapCoordinate(row: coordinates.row + 1, col: coordinates.col)
            
            if nextPipePiece(from: nextCoordinates, heading: .south, debug: DEBUG) != nil {
                return .south
            }
        }
        
        print("! No valid direction found for coordinates:", coordinates)
        return Optional.none
    }
    
    // If the direction is valid, return the pipe piece in that direction
    func nextPipePiece(from nextCoordinates: MapCoordinate, heading pipeHeading: MapDirection, debug: Bool = false) -> PipePiece? {
        
        let nextChar = pipeCharacter(at: nextCoordinates)
        
        if let nextPipeDirection = nextDirection(approaching: nextChar, heading: pipeHeading) {
            
            let nextPipePiece = PipePiece(pipeChar: nextChar, coordinates: nextCoordinates, headingOfNextPipe: pipeHeading.opposite)
            
            if debug {
                print("NextChar", nextChar, "Pipe Heading:", pipeHeading, "Next Direction:", nextPipeDirection)
            }
            
            return nextPipePiece
        }
        
        return nil
    }
    
    func pipeCharacter(at coordinates: MapCoordinate) -> Character {
        let pipeChar = entities[coordinates.row][coordinates.col]
        
//        print("Coords", coordinates, "Char:", pipeChar)
        
        return pipeChar
    }
    
    func nextCoordinates(startingAt coordinates: MapCoordinate, heading pipeHeading: MapDirection) -> MapCoordinate {
        switch pipeHeading {
        case .north:
            return MapCoordinate(row: coordinates.row - 1, col: coordinates.col)
        case .south:
            return MapCoordinate(row: coordinates.row + 1, col: coordinates.col)
        case .east:
            return MapCoordinate(row: coordinates.row, col: coordinates.col + 1)
        case .west:
            return MapCoordinate(row: coordinates.row, col: coordinates.col - 1)
        }
    }
    
    func isPipeCharValid(pipeChar: Character, intoDirection: MapDirection) -> Bool {
        
        switch (intoDirection, pipeChar) {
        
        // E.g. Going North, you can only continue if you get one of:
        // - "|", "7" or "F" characters.\
        // All other characters are invalid
            
            // North
        case (.north, "|"):
            return true
        case (.north, "7"):
            return true
        case (.north, "F"):
            return true
            
            // South
        case (.south, "|"):
            return true
        case (.south, "L"):
            return true
        case (.south, "J"):
            return true
            
            // East
        case (.east, "-"):
            return true
        case (.east, "J"):
            return true
        case (.east, "7"):
            return true
            
            // West
        case (.west, "-"):
            return true
        case (.west, "L"):
            return true
        case (.west, "F"):
            return true
            
            // Any other cases are for invalid pipes
            // Need to handle "S" case seperately
        default:
            return false
        }
    }
    
    func nextDirection(approaching pipeChar: Character, heading nextPipeDirection: MapDirection) -> MapDirection? {
        
        // E.g. "J" If you're travelling TO the East then you are coming FROM the West so you must go North
        
        switch (nextPipeDirection, pipeChar) {
        
            // North cases
        case (.north, "|"), (.west, "L"), (.east, "J"):
            return .north
            
            // South cases
        case (.south, "|"), (.west, "F"), (.east, "7"):
            return .south
            
            // East cases
        case (.east, "-"), (.south, "L"), (.north, "F"):
            return .east
            
            // West cases
        case (.west, "-"), (.south, "J"), (.north, "7"):
            return .west
            
        case (let direction, "S"):
            return direction
            
        default:
            return nil
        }
    }
    
}
