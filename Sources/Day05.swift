import Algorithms
import Foundation

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    func part1() -> Any {
        
        let DEBUG = false
        
        var scratchCardSum: Int = 0
        
        for line in entities {
            print(line)
            
        }
        return scratchCardSum
    }
}
