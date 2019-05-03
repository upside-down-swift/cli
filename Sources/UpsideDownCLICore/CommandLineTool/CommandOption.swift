//
//  CommandOption.swift
//  CLICore
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

public struct CommandOption {
    public static func option<Kind: ArgumentKind>(_ name: String, kind: Kind.Type, shortName: String? = nil, usage: String? = nil, completion: ShellCompletion? = nil) -> CommandOption {
        return CommandOption() { $0.add(option: createLongName(name), shortName: createShortName(shortName), kind: kind, usage: usage, completion: completion) }
    }
    
    public static func option<Kind: ArgumentKind>(_ name: String, kind: [Kind].Type, shortName: String? = nil, usage: String? = nil, completion: ShellCompletion? = nil) -> CommandOption {
        return CommandOption() { $0.add(option: createLongName(name), shortName: createShortName(shortName), kind: kind, usage: usage, completion: completion) }
    }
    
    public static func positional<Kind: ArgumentKind>(_ name: String, kind: Kind.Type, optional: Bool = false, usage: String? = nil, completion: ShellCompletion? = nil) -> CommandOption {
        return CommandOption() { $0.add(positional: name, kind: kind, optional: optional, usage: usage, completion: completion) }
    }
    
    public static func positional<Kind: ArgumentKind>(_ name: String, kind: [Kind].Type, optional: Bool = false, usage: String? = nil, completion: ShellCompletion? = nil) -> CommandOption {
        return CommandOption() { $0.add(positional: name, kind: kind, optional: optional, usage: usage, completion: completion) }
    }
    
    public static func createLongName(_ name: String) -> String {
        return "--\(name)"
    }
    
    public static func createShortName(_ name: String?) -> String? {
        guard let name = name else {
            return nil
        }
        
        return "-\(name)"
    }
    
    private let parserModification: (ArgumentParser) -> AnyArgument
    
    public func argument(from parser: ArgumentParser) -> AnyArgument {
        return parserModification(parser)
    }
}
