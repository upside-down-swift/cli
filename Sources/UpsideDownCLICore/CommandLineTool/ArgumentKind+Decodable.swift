//
//  ArgumentKind+Decodable.swift
//
//  Created by Marcus Smith on 4/29/19.
//

import Foundation
import Utility

extension Double: ArgumentKind {
    public init(argument: String) throws {
        guard let double = Double(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Double.self)
        }
        
        self = double
    }
    
    public static let completion: ShellCompletion = .none
}

extension Float: ArgumentKind {
    public init(argument: String) throws {
        guard let float = Float(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Float.self)
        }
        
        self = float
    }
    
    public static let completion: ShellCompletion = .none
}

extension Int8: ArgumentKind {
    public init(argument: String) throws {
        guard let int = Int8(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int8.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension Int16: ArgumentKind {
    public init(argument: String) throws {
        guard let int = Int16(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int16.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension Int32: ArgumentKind {
    public init(argument: String) throws {
        guard let int = Int32(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int32.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension Int64: ArgumentKind {
    public init(argument: String) throws {
        guard let int = Int64(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int64.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension UInt: ArgumentKind {
    public init(argument: String) throws {
        guard let int = UInt(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: UInt.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension UInt8: ArgumentKind {
    public init(argument: String) throws {
        guard let int = UInt8(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: UInt8.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension UInt16: ArgumentKind {
    public init(argument: String) throws {
        guard let int = UInt16(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: UInt16.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension UInt32: ArgumentKind {
    public init(argument: String) throws {
        guard let int = UInt32(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: UInt32.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}

extension UInt64: ArgumentKind {
    public init(argument: String) throws {
        guard let int = UInt64(argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: UInt64.self)
        }
        
        self = int
    }
    
    public static let completion: ShellCompletion = .none
}
