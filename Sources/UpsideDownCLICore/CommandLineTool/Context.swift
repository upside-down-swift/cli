//
//  Context.swift
//  UpsideDownCLI
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

public class Context {
    public struct Error: LocalizedError {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        public var errorDescription: String? {
            return message
        }
    }
    
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
            throw Error("Invalid argument: No script")
        }
        
        let url = try getURL(scriptPath)
        _scriptURL = url
        return url
    }
    
    private func getURL(_ scriptPath: String) throws -> URL {
        let fm = FileManager.default
        
        if scriptPath.hasPrefix("/") {
            if fm.fileExists(atPath: scriptPath) {
                return URL(fileURLWithPath: scriptPath).resolvingSymlinksInPath()
            } else {
                throw Error("Script does not exist at path \(scriptPath)")
            }
        } else {
            let cwdURL = URL(fileURLWithPath: fm.currentDirectoryPath)
            if let scriptUrl = URL(string: scriptPath, relativeTo: cwdURL), fm.fileExists(atPath: scriptUrl.path) {
                return scriptUrl
            } else {
                let which = Process()
                which.launchPath = "sh"
                which.arguments = ["-c", "which \(scriptPath)"]
                
                let pipe = Pipe()
                which.standardOutput = pipe
                which.launch()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let whichPath = String(decoding: data, as: UTF8.self)
                
                if fm.fileExists(atPath: whichPath) {
                    return URL(fileURLWithPath: whichPath).resolvingSymlinksInPath()
                } else {
                    throw Error("Cannot find script \(scriptPath)")
                }
            }
        }
    }
}
