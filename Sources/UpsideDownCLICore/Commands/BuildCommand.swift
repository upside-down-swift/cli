//
//  BuildCommand.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Files
import Utility

struct BuildCommand: Command, OptionDecodable {
    enum Key: String, CodingKey {
        case configurationPath, outputPath, test
    }
    
    static let overview: String = "Builds an Upside Down application"
    static let options: [Key: CommandOption] = [
        .configurationPath: .option("configuration", kind: String.self, shortName: "c", usage: "path to configuration file", completion: .filename),
        .outputPath: .option("output", kind: String.self, shortName: "o", usage: "path to output directory", completion: .filename),
        .test: .positional("test", kind: String.self, optional: false, usage: "just for testing", completion: .values([
            (value: "help", description: "show buildctl help"),
            (value: "version", description: "show buildctl version")
        ]))
    ]
    
    let configurationPath: String?
    let outputPath: String?
    let test: String
    
    func execute() throws {
        // FIXME: Create a Dockerfile in bin with the cli or in a tmp folder
//        if !Folder.current.containsFile(named: "Dockerfile") {
//            try Folder.current.createFile(named: "Dockerfile", contents: "I'm a dockerfile?!", encoding: .utf8)
//        }
        
        if let path = configurationPath {
            print("Config: \(path)")
        }
        
        if let path = outputPath {
            print("Output: \(path)")
        }
        
        let buildctl = Process()
        buildctl.launchPath = "/usr/local/bin/buildctl"
        
        switch test {
        case "help":
            buildctl.arguments = ["--help"]
        case "version":
            buildctl.arguments = ["--version"]
        default:
            break
        }
        
        buildctl.launch()
        buildctl.waitUntilExit()
    }
}
