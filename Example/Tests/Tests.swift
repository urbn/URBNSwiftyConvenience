import UIKit
import XCTest
import URBNSwiftyConvenience

class Tests: XCTestCase {
    
    func testColors() {
        XCTAssertEqual(UIColor(rgb: 0xFF0000), UIColor.red)
        XCTAssertEqual(UIColor(rgb: 0x00FF00), UIColor.green)
        XCTAssertEqual(UIColor(rgb: 0x0000FF), UIColor.blue)
        XCTAssertEqual(UIColor(rgb: 0x00FFFF), UIColor.cyan)
        XCTAssertEqual(UIColor(rgb: 0xFFFF00), UIColor.yellow)
        
        XCTAssertEqual(UIColor(hexString: "FF0000"), UIColor.red)
        XCTAssertEqual(UIColor(hexString: "#00FF00"), UIColor.green)
        XCTAssertEqual(UIColor(hexString: "0000FF"), UIColor.blue)
        XCTAssertEqual(UIColor(hexString: "#00FFFF"), UIColor.cyan)
        XCTAssertEqual(UIColor(hexString: "FFFF00"), UIColor.yellow)

        XCTAssertEqual(UIColor(hexString: "FFFF0"), UIColor(rgb: 0))
        XCTAssertEqual(UIColor(hexString: "#FFFF0"), UIColor(rgb: 0))
        XCTAssertEqual(UIColor(hexString: "Jerkface"), UIColor(rgb: 0))
    }
    
    func testConditionalAssignment() {
        var myDictionary = [String: String]()
        let missing: String? = nil
        let exists: String? = "baz"
        
        myDictionary["foo"] ?= missing
        myDictionary["bar"] ?= exists
        
        XCTAssertNil(myDictionary["foo"])
        XCTAssertEqual(myDictionary["bar"], "baz")
    }
    
    func testStableSort() {
        struct Person: Equatable {
            let name: String
            let age: Int
            
            static func == (lhs: Person, rhs: Person) -> Bool {
                return lhs.name == rhs.name && lhs.age == rhs.age
            }
        }
        
        let kristin = Person(name: "Kristin", age: 31)
        let steve = Person(name: "Steve", age: 34)
        let john = Person(name: "John", age: 34)
        let dave = Person(name: "Dave", age: 40)
        let bob = Person(name: "Bob", age: 32)
        let joe = Person(name: "Joe", age: 32)
        
        let people = [dave, kristin, steve, john, bob, joe]
        let ascSorted = people.stableSorted(by: { $0.age < $1.age })
        let descSorted = people.stableSorted(by: { $0.age > $1.age })
        
        XCTAssert([kristin, bob, joe, steve, john, dave] == ascSorted)
        XCTAssert([dave, steve, john, bob, joe, kristin] == descSorted)
    }
}

