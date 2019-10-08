import XCTest
@testable import URBNSwiftyConvenience

final class URBNSwiftyConvenienceTests: XCTestCase {
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

    static var allTests = [
        ("testColors", testColors),
        ("testConditionalAssignment", testConditionalAssignment),
    ]
}
