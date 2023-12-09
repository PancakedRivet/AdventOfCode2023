import Algorithms
import Foundation

struct Day07: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map { String($0) }
    }
    
    struct cardHand {
        let handType: HandType
        let handCards: String
        let bid: Int
    }
    
    enum HandType: Int {
        case fiveKind = 7
        case fourKind = 6
        case fullHouse = 5
        case threeKind = 4
        case twoPair = 3
        case onePair = 2
        case highCard = 1
    }

    func part1() -> Any {
        
        let DEBUG = false
        
        var listOfCardHands: [cardHand] = []
        
        for line in entities {
            let lineSplit = line.split(separator: " ")
            let hand = String(lineSplit[0])
            let bid = Int(lineSplit[1])!
            let handType = checkHand(hand: hand)
            
            let cardHand = cardHand(handType: handType, handCards: hand, bid: bid)
            
            listOfCardHands.append(cardHand)
            
            if DEBUG {
                print("Hand:", cardHand)
            }
        }
        
        // We need to apply 2 sort operations:
        // 1. Sort by the handType
        // 2. Sort by the cards in each hand when they have equal handTypes
        listOfCardHands.sort { (lhs: cardHand, rhs: cardHand) -> Bool in
            if lhs.handType.rawValue == rhs.handType.rawValue {
                // Perform the secondary sort
                
                let lhsCharacterList = lhs.handCards.map { String($0) }
                let rhsCharacterList = rhs.handCards.map { String($0) }
                
                var lhsCardValue = checkValue(cardLabel: lhsCharacterList[0])
                var rhsCardValue = checkValue(cardLabel: rhsCharacterList[0])
                
                if lhsCardValue == rhsCardValue {
                    for idx in 1...5 {
                        lhsCardValue = checkValue(cardLabel: lhsCharacterList[idx])
                        rhsCardValue = checkValue(cardLabel: rhsCharacterList[idx])
                        
                        // Only continue until the card values are not equal
                        if lhsCardValue != rhsCardValue {
                            break
                        }
                    }
                }
                
                return lhsCardValue > rhsCardValue
            } else {
                return lhs.handType.rawValue > rhs.handType.rawValue
            }
        }
        
        if DEBUG {
            print("Sorted Hand List:")
            for cardHand in listOfCardHands {
                print(cardHand)
            }
        }
        
        // Calculate the winnings
        var totalWinnings = 0
        for (idx, cardHand) in listOfCardHands.enumerated() {
            totalWinnings += (listOfCardHands.count - idx) * cardHand.bid
        }
        
        return totalWinnings
    }
    
    func part2() -> Any {
        
        let DEBUG = false
        
        var listOfCardHands: [cardHand] = []
        
        for line in entities {
            let lineSplit = line.split(separator: " ")
            let hand = String(lineSplit[0])
            let bid = Int(lineSplit[1])!
            let handType = checkHand(hand: hand, isPart2: true)
            
            let cardHand = cardHand(handType: handType, handCards: hand, bid: bid)
            
            listOfCardHands.append(cardHand)
            
            if DEBUG {
                print("Hand:", cardHand)
            }
        }
        
        // We need to apply 2 sort operations:
        // 1. Sort by the handType
        // 2. Sort by the cards in each hand when they have equal handTypes
        listOfCardHands.sort { (lhs: cardHand, rhs: cardHand) -> Bool in
            if lhs.handType.rawValue == rhs.handType.rawValue {
                // Perform the secondary sort
                
                let lhsCharacterList = lhs.handCards.map { String($0) }
                let rhsCharacterList = rhs.handCards.map { String($0) }
                
                var lhsCardValue = checkValue(cardLabel: lhsCharacterList[0], isPart2: true)
                var rhsCardValue = checkValue(cardLabel: rhsCharacterList[0], isPart2: true)
                
                if lhsCardValue == rhsCardValue {
                    for idx in 1...5 {
                        lhsCardValue = checkValue(cardLabel: lhsCharacterList[idx], isPart2: true)
                        rhsCardValue = checkValue(cardLabel: rhsCharacterList[idx], isPart2: true)
                        
                        // Only continue until the card values are not equal
                        if lhsCardValue != rhsCardValue {
                            break
                        }
                    }
                }
                
                return lhsCardValue > rhsCardValue
            } else {
                return lhs.handType.rawValue > rhs.handType.rawValue
            }
        }
        
        if DEBUG {
            print("Sorted Hand List:")
            for cardHand in listOfCardHands {
                print(cardHand)
            }
        }
        
        // Calculate the winnings
        var totalWinnings = 0
        for (idx, cardHand) in listOfCardHands.enumerated() {
            totalWinnings += (listOfCardHands.count - idx) * cardHand.bid
        }
        
        return totalWinnings
    }
    
    func checkHand(hand: String, isPart2: Bool = false) -> HandType {
        
        var handCards: [String: Int] = [:]
        
        for char in hand {
            let oldValue = handCards[String(char), default: 0]
            let newValue = oldValue + 1
            handCards[String(char)] = newValue
        }
        
        // Sort the dictionary from high to low
        var sortedValues = handCards.sorted { $0.value > $1.value }
        
        // Part 2 check: Add all Js to the highest count:
        if isPart2 && handCards["J", default: 0] > 0 && handCards.count > 1 {
            // Remove the J entry and add the count to the next highest card
            sortedValues = sortedValues.filter { $0.key != "J" }
            sortedValues[0].value += handCards["J"]!
        }
        
        // We can determine the hand type from the highest 2 keys and values
        let max2Keys = Array(sortedValues.prefix(2))
        
        let highestCount = max2Keys[0].value
        var secondCount = 0
        if (max2Keys.count == 2) {
            secondCount = max2Keys[1].value
        }
        
        let handType = checkHandType(highest: highestCount, secondHighest: secondCount)
        
        return handType
    }
    
    func checkValue(cardLabel: String, isPart2: Bool = false) -> Int {
        
        let cardValue = switch cardLabel {
        case "A": 14
        case "K": 13
        case "Q": 12
        case "J": 11
        case "T": 10
        case "9": 9
        case "8": 8
        case "7": 7
        case "6": 6
        case "5": 5
        case "4": 4
        case "3": 3
        case "2": 2
        // Part 2: case "J": 1
        default: 0
        }
        
        if isPart2 && cardLabel == "J" {
            return 1
        }
        
        return cardValue
    }
    
    func checkHandType(highest: Int, secondHighest: Int) -> HandType {
        
        let handType = switch (highest, secondHighest) {
        case (5, 0):
            HandType.fiveKind
        case (4, 1):
            HandType.fourKind
        case (3, 2):
            HandType.fullHouse
        case (3, 1):
            HandType.threeKind
        case (2, 2):
            HandType.twoPair
        case (2, 1):
            HandType.onePair
        default:
            HandType.highCard
        }
        
        return handType
    }
    
}
