//
//  CLIError.swift
//  UpsideDownCLI
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

public struct CLIError: LocalizedError {
    public let message: String
    public let exitCode: Int32
    
    public init(_ message: String, exitCode: Int32 = 1) {
        self.message = message
        self.exitCode = exitCode
    }
    
    public var errorDescription: String? {
        return message
    }
}
