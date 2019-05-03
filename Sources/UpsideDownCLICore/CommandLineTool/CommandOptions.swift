//
//  CommandOptions.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public class CommandOptions {
    public struct Error: LocalizedError {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var errorDescription: String? {
            return message
        }
    }

    private let parser: ArgumentParser
    public private(set) var arguments: [String: AnyArgument] = [:]
    public private(set) var keys: [String] = []
    
    public init(parser: ArgumentParser) {
        self.parser = parser
    }
    
    public func add<Key: CodingKey>(key: Key, option: CommandOption) {
        arguments[key.stringValue] = option.argument(from: parser)
        keys.append(key.stringValue)
    }
    
    public func adding<Key: CodingKey>(key: Key, option: CommandOption) -> Self {
        add(key: key, option: option)
        return self
    }
}
