//
//  CommandLineTool.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Basic
import Utility

open class CommandLineTool {
    public struct Error: LocalizedError {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var errorDescription: String? {
            return message
        }
    }
    
    let argParser: ArgumentParser
    private var commands: [String?: (type: Command.Type, options: CommandOptions)] = [:]
    
    public convenience init(_ defaultCommand: Command.Type, subCommands: [String: Command.Type] = [:], usage: String, seeAlso: String? = nil) {
        self.init(defaultCommand: defaultCommand, subCommands: subCommands, usage: usage, overview: defaultCommand.overview, seeAlso: seeAlso)
    }
    
    public convenience init(commands: [String: Command.Type], usage: String, overview: String, seeAlso: String? = nil) {
        self.init(defaultCommand: nil, subCommands: commands, usage: usage, overview: overview, seeAlso: seeAlso)
    }
    
    // TODO: Shared arguments (verbose, etc)
    private init(defaultCommand: Command.Type?, subCommands: [String: Command.Type] = [:], usage: String, overview: String, seeAlso: String?) {
        argParser = ArgumentParser(commandName: nil, usage: usage, overview: overview, seeAlso: seeAlso)
        subCommands.forEach { (pair) in
            let subParser = argParser.add(subparser: pair.key, overview: pair.value.overview)
            commands[pair.key] = (type: pair.value, options: pair.value.generateOptions(from: subParser))
        }
        if let defaultCommand = defaultCommand {
            commands[nil] = (type: defaultCommand, options: defaultCommand.generateOptions(from: argParser))
        }
    }
    
    public func run(arguments: [String]) throws {
        let result = try argParser.parse(Array(arguments.dropFirst()))
        // TODO: Parse shared arguments
        let commandName = result.subparser(argParser)
        guard let commandInfo = commands[commandName] else {
            argParser.printUsage(on: stdoutStream) // TODO: Log levels etc?
            let commandString = commandName != nil ? "\(commandName!) " : ""
            throw Error("Command \(commandString)does not exist")
        }
        
        let command = try commandInfo.type.from(result: result, options: commandInfo.options)
        try command.execute()
    }
}
