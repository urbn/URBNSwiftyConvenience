//
//  AnyError.swift
//  URBNSwiftyConvenience
//
//  Created by Matt Thomas on 2/4/19.
//

import Foundation

public struct AnyError: Swift.Error, CustomStringConvertible {
    /// The underlying error.
    public let underlyingError: Swift.Error
    
    public init(_ error: Swift.Error) {
        // If we already have any error, don't nest it.
        if case let error as AnyError = error {
            self = error
        } else {
            self.underlyingError = error
        }
    }
    
    public var description: String {
        return String(describing: underlyingError)
    }
}
