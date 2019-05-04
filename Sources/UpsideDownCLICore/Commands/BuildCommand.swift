//
//  BuildCommand.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

struct BuildCommand: Command, OptionDecodable {
    enum Key: String, CodingKey {
        case configurationURL, outputPath, test
    }
    
    static let overview: String = "Builds an Upside Down application"
    static let options: [Key: CommandOption] = [
        .configurationURL: .option("configuration", kind: String.self, shortName: "c", usage: "path to configuration file", completion: .filename),
        .outputPath: .option("output", kind: String.self, shortName: "o", usage: "path to output directory", completion: .filename),
        .test: .positional("test", kind: String.self, optional: false, usage: "just for testing", completion: .values([
            (value: "help", description: "show buildctl help"),
            (value: "version", description: "show buildctl version")
        ]))
    ]
    
    let configurationURL: Foundation.URL?
    let outputPath: String?
    let test: String
    
    func execute(in context: Context) throws {
        if test == "dockerfile" {
            let dockerfileURL = try getDockerfileURL(in: context)
            let data = try String(contentsOf: dockerfileURL, encoding: .utf8)
            print(data)
            return
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
    
    private func getDockerfileURL(in context: Context) throws -> Foundation.URL {
        let configURL: Foundation.URL = try {
            if let url = configurationURL {
                return url
            } else {
                return try context.defaultConfigurationURL()
            }
            }()
        
        let config = try Configuration.from(url: configURL)
        let pipeline = config.version
        let pipelineDir = try context.pipelineDirectory()
        
        guard let dockerfileURL = URL(string: "\(pipeline)/Dockerfile", relativeTo: pipelineDir) else {
            throw CLIError("Unable to find Dockerfile in \(pipelineDir.path)/\(pipeline)")
        }
        
        let fm = FileManager.default
        
        guard fm.fileExists(atPath: dockerfileURL.path) else {
            throw CLIError("Dockerfile does not exist at \(dockerfileURL.path)")
        }
        
        return dockerfileURL
    }
}
