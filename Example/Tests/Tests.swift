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
    }
}

