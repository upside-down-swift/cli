//
//  BuildCommand.swift
//
//  Created by Marcus Smith on 4/28/19.
//

import Foundation
import Utility

struct BuildCommand: Command, OptionDecodable {
    enum Key: String, CodingKey {
        case buildConfigurationPath, isDryRun
    }
    
    static let overview: String = "Builds an Upside Down application"
    static let options: [Key: CommandOption] = [
        .buildConfigurationPath: .option("configuration", kind: String.self, shortName: "c", usage: "path to configuration file, default is upside-down-build.plist in working directory", completion: .filename),
        .isDryRun: .option("dry-run", kind: Bool.self, shortName: nil, usage: "prints buildctl command instead of running it")
    ]
    
    let buildConfigurationPath: Path?
    let isDryRun: Bool
    
    func execute(in context: Context) throws {
        let buildConfigURL = buildConfigurationPath?.rawValue ?? URL(fileURLWithPath: "upside-down-build.plist")
        let buildConfig = try BuildConfiguration.from(url: buildConfigURL)
        
        let appConfig = try context.loadConfiguration()
        let dockerfileURL = try getDockerfileURL(in: context)
        
        let launchPath = appConfig.buildctlPath
        
        var arguments: [String] = [
            "build",
            "--frontend",
            "dockerfile.v0",
            "--local",
            "dockerfile=\(dockerfileURL.path)",
            "--opt",
            "--target=\(buildConfig.target)"
        ]
        
        buildConfig.stages.forEach {
            arguments.append("--opt")
            arguments.append("build-arg:\($0.key)=\($0.value)")
        }
        
        if isDryRun {
            print(([launchPath] + arguments).joined(separator: " "))
            return
        }
        
        let buildctl = Process()
        buildctl.launchPath =  launchPath
        buildctl.arguments = arguments
        
        buildctl.launch()
        buildctl.waitUntilExit()
    }
    
    private func getDockerfileURL(in context: Context) throws -> Foundation.URL {
        let config = try context.loadConfiguration()
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
