//
//  ResultType.swift
//  Pods
//
//  Created by Bueno McCartney on 12/7/16.
//
//

import Foundation

public enum Result<Success> {
    case success(Success)
    case failure(Error)
}

extension Result {
    public var value: Success? {
        switch self {
        case .success(let v): return v
        default: return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .failure(let e): return e
        default: return nil
        }
    }
    
    public init(_ error: Error) {
        self = .failure(error)
    }
    
    public init(_ value: Success) {
        if let v = value as? Error {
            self = .failure(v)
        }
        else {
            self = .success(value)
        }
    }
    
    public init(catching body: () throws -> Success) {
        do {
            self = .success(try body())
        } catch {
            self = .failure(error)
        }
    }
}


public extension Result {
    public var isEmpty: Bool {
        return value == nil
    }
}

// MARK: - Helper Handling -
public extension Result {
    public func onSuccess(handler: (_ data: Success) -> Void) {
        switch(self) {
        case .success(let data): handler(data)
        default: break
        }
    }
    
    public func onError(handler: (_ err: Error) -> Void) {
        switch(self) {
        case .failure(let e): handler(e)
        default: break
        }
    }
}

public extension Result where Success:Equatable {
    public static func ==(lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsVal), .success(let rhsVal)):
            // Two successes are equal if their internal vals are equal
            return lhsVal == rhsVal
            
        case (.failure(let lhsErr), .failure(let rhsErr)):
            // Two errors are equal if their _domain's and _code's are equal
            return lhsErr._domain == rhsErr._domain && lhsErr._code == rhsErr._code
            
        default: return false
        }
    }
}

@objc public class NoResponseType: NSObject {}

// MARK: - Apple Compatibility -
extension Result {
    public func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess> {
        switch self {
        case let .success(success):
            return .success(transform(success))
        case let .failure(failure):
            return .failure(failure)
        }
    }

    public func flatMap<NewSuccess>(_ transform: (Success) -> Result<NewSuccess>) -> Result<NewSuccess> {
        switch self {
        case let .success(success):
            return transform(success)
        case let .failure(failure):
            return .failure(failure)
        }
    }
    
    public func get() throws -> Success {
        switch self {
        case let .success(success):
            return success
        case let .failure(failure):
            throw failure
        }
    }
}
