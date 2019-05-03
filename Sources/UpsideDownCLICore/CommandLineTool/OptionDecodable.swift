//
//  OptionDecodable.swift
//  CLICore
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public protocol OptionDecodable: Decodable {
    associatedtype Key where Key: Hashable & CodingKey
    static var options: [Key: CommandOption] { get }
}

public extension Command where Self: OptionDecodable {
    static func from(result: ArgumentParser.Result, options: CommandOptions) throws -> Self {
        let decoder = ArgumentDecoder(result: result, options: options)
        return try Self.init(from: decoder)
    }
    
    static func generateOptions(from parser: ArgumentParser) -> CommandOptions {
        return options.reduce(CommandOptions(parser: parser)) { $0.adding(key: $1.key, option: $1.value) }
    }
}
