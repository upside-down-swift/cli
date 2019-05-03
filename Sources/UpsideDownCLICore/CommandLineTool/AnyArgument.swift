//
//  CommandOption.swift
//  CLICore
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public struct ArgumentError: LocalizedError {
    public let expected: String
    public let actual: String
    
    public var errorDescription: String? {
        return "Expected \(expected) but type was \(actual)"
    }
}

public protocol AnyArgument {
    func get<T>(_ type: T.Type, from result: ArgumentParser.Result) throws -> T?
    func getAsArray(from result: ArgumentParser.Result) throws -> Array<Any>?
}

extension OptionArgument: AnyArgument {
    public func get<T>(_ type: T.Type, from result: ArgumentParser.Result) throws -> T? {
        guard let value = result.get(self) else {
            return nil
        }
        
        guard let castValue = value as? T else {
            throw ArgumentError(expected: String(describing: T.self), actual: String(describing: Kind.self))
        }
        
        return castValue
    }
    
    public func getAsArray(from result: ArgumentParser.Result) throws -> Array<Any>? {
        guard let value = result.get(self) else {
            return nil
        }
        
        guard let array = value as? Array<Any> else {
            throw ArgumentError(expected: "Array", actual: "\(String(describing: value))")
        }
        
        return array
    }
}

extension PositionalArgument: AnyArgument {
    public func get<T>(_ type: T.Type, from result: ArgumentParser.Result) throws -> T? {
        guard let value = result.get(self) else {
            return nil
        }
        
        guard let castValue = value as? T else {
            throw ArgumentError(expected: String(describing: T.self), actual: String(describing: Kind.self))
        }
        
        return castValue
    }
    
    public func getAsArray(from result: ArgumentParser.Result) throws -> Array<Any>? {
        guard let value = result.get(self) else {
            return nil
        }
        
        guard let array = value as? Array<Any> else {
            throw ArgumentError(expected: "Array", actual: "\(String(describing: value))")
        }
        
        return array
    }
}
