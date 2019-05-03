//
//  Command.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public protocol Command {
    static func generateOptions(from: ArgumentParser) -> CommandOptions
    static func from(result: ArgumentParser.Result, options: CommandOptions) throws -> Self
    static var overview: String { get }
    func execute(in: Context) throws
}
