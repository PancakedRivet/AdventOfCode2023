import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day08Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """
    
    func testPart1() throws {
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "6440")
    }
    
    func testPart2() throws {
        let challenge = Day08(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
