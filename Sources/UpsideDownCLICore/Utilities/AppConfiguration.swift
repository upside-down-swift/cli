//
//  AppConfiguration.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

public struct AppConfiguration: Codable {
    public static func from(url: URL) throws -> AppConfiguration {
        let data = try Data(contentsOf: url)
        return try PropertyListDecoder().decode(AppConfiguration.self, from: data)
    }
    
    public var version: String
    public var buildctlPath: String
    
    public func save(to url: URL) throws {
        let data = try PropertyListEncoder().encode(self)
        try data.write(to: url)
    }
}
