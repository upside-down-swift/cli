//
//  Context+URLs.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

extension Context {
    func loadConfiguration() throws -> AppConfiguration {
        if let configuration = values["config"] as? AppConfiguration {
            return configuration
        }
        
        let url = try appConfigurationURL()
        let config = try AppConfiguration.from(url: url)
        values["config"] = config
        return config
    }
    
    func etcDirectory() throws -> URL {
        if let testPath = environment["TEST_ETC"] {
            return URL(fileURLWithPath: testPath)
        }
        
        let scriptURL = try getAbsoluteScriptURL()
        
        guard let url = URL(string: "../etc/", relativeTo: scriptURL) else {
            throw CLIError("etc subdirectory not found in \(scriptURL.path)")
        }
        
        return url
    }
    
    func pipelineDirectory() throws -> URL {
        let etcDir = try etcDirectory()
        
        guard let url = URL(string: "pipelines/", relativeTo: etcDir) else {
            throw CLIError("pipelines subdirectory not found in \(etcDir.path)")
        }
        
        return url
    }
    
    func appConfigurationURL() throws -> URL {
        let etcDir = try etcDirectory()
        
        guard let url = URL(string: "upside-down.plist", relativeTo: etcDir) else {
            throw CLIError("configuration not found in \(etcDir.path)")
        }
        
        return url
    }
}
