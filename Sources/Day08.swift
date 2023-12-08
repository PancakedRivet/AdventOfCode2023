import Algorithms
import Foundation

struct Day08: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }

    func part1() -> Any {
        
        let DEBUG = false
        
        for line in entities {
            print(line)
        }
        return 0
    }
    
}
