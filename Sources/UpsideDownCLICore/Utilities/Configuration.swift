//
//  Configuration.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/3/19.
//

import Foundation

public struct Configuration: Codable {
    public static func from(url: URL) throws -> Configuration {
        let data = try Data(contentsOf: url)
        return try PropertyListDecoder().decode(Configuration.self, from: data)
    }
    
    public var version: String
    
    public func save(to url: URL) throws {
        let data = try PropertyListEncoder().encode(self)
        try data.write(to: url)
    }
}
