//
//  Array+Extensions.swift
//  URBNSwiftyConvenience
//
//  Created by Bueno on 10/9/18.
//

import Foundation

extension RandomAccessCollection {
    /// From: https://stackoverflow.com/a/45585365/1541526
    /// return a sorted collection
    /// this use a stable sort algorithm
    ///
    /// - Parameter areInIncreasingOrder: return nil when two element are equal
    /// - Returns: the sorted collection
    public func stableSorted(by areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool?) -> [Iterator.Element] {
        
        let sorted = self.enumerated().sorted { (one, another) -> Bool in
            if let result = areInIncreasingOrder(one.element, another.element) {
                return result
            } else {
                return one.offset < another.offset
            }
        }
        
        return sorted.map{ $0.element }
    }
}
