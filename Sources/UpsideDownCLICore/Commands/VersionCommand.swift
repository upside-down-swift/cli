//
//  VersionCommand.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

struct VersionCommand: Command, OptionDecodable {
    enum Key: String, CodingKey {
        case all, value
    }
    
    static let overview: String = "Manage default Upside Down Swift build pipeline versions"
    static let options: [Key: CommandOption] = [
        .all: .option("all", kind: Bool.self, shortName: "a", usage: "Show all available pipeline versions"),
        .value: .option("set", kind: String.self, shortName: nil, usage: "Set pipeline version")
    ]
    
    let all: Bool
    let value: String?
    
    func execute(in context: Context) throws {
        if all && value != nil {
            throw CLIError("Cannot use both set and all options")
        }
        
        if let value = value {
            let allVersions = try getAllVersions(in: context)
            guard allVersions.contains(value) else {
                throw CLIError("version \(value) not installed")
            }
            
            let configURL = try context.defaultConfigurationURL()
            var config = try Configuration.from(url: configURL)
            config.version = value
            try config.save(to: configURL)
        } else if all {
            let current = try getCurrentVersion(in: context)
            let allVersions = try getAllVersions(in: context)
            allVersions.forEach { print("\($0)\($0 == current ? "*" : "")") }
        } else {
            print(try getCurrentVersion(in: context))
        }
    }
    
    private func getCurrentVersion(in context: Context) throws -> String {
        let config = try Configuration.from(url: try context.defaultConfigurationURL())
        return config.version
    }
    
    private func getAllVersions(in context: Context) throws -> [String] {
        let pipelinesURL = try context.pipelineDirectory()
        let contents = try FileManager.default.contentsOfDirectory(atPath: pipelinesURL.path)
        return contents.sorted(by: >)
    }
}
