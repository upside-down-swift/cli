//
//  Context.swift
//  UpsideDownCLI
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

public class Context {
    public let arguments: [String]
    private var _scriptURL: URL?
    
    public init(_ arguments: [String]) {
        self.arguments = arguments
    }
    
    public func getAbsoluteScriptURL() throws -> URL {
        if let url = _scriptURL {
            return url
        }
        
        guard let scriptPath = arguments.first else {
            throw CLIError("Invalid arguments")
        }
        
        let url = try getURL(scriptPath)
        _scriptURL = url
        return url
    }
    
    private func getURL(_ scriptPath: String) throws -> URL {
        if scriptPath.hasPrefix("/") {
            return try validateURL(URL(fileURLWithPath: scriptPath))
        } else {
            let cwdURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            if let scriptUrl = URL(string: scriptPath, relativeTo: cwdURL), let validURL = try? validateURL(scriptUrl) {
                return validURL
            } else {
                let which = Process()
                which.launchPath = "/usr/bin/which"
                which.arguments = [scriptPath]
                
                let pipe = Pipe()
                which.standardOutput = pipe
                which.launch()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let whichPath = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
                return try validateURL(URL(fileURLWithPath: whichPath))
            }
        }
    }
    
    private func validateURL(_ url: URL) throws -> URL {
        var validURL = url
        if try isAlias(url) {
            validURL = try URL(resolvingAliasFileAt: url) // TODO: Does this need to be done for every path components?
        }
        
        guard FileManager.default.fileExists(atPath: validURL.path) else {
            throw CLIError("\(validURL.path) does not exist")
        }
        
        return validURL
    }
    
    private func isAlias(_ url: URL) throws -> Bool {
        let resourceValues = try url.resourceValues(forKeys: [.isAliasFileKey])
        return resourceValues.isAliasFile == true
    }
}
