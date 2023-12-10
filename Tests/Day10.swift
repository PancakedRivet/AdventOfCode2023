import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day10Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
    
    func testPart1() throws {
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }
    
    func testPart2() throws {
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "114")
    }
}
