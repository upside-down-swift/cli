//
//  Context+URLs.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

extension Context {
    func etcDirectory() throws -> URL {
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
    
    func defaultConfigurationURL() throws -> URL {
        let etcDir = try etcDirectory()
        
        guard let url = URL(string: "default-config.plist", relativeTo: etcDir) else {
            throw CLIError("default config not found in \(etcDir.path)")
        }
        
        return url
    }
}
