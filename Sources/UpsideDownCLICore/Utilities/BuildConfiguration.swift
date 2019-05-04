//
//  BuildConfiguration.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/4/19.
//

import Foundation

public struct BuildConfiguration: Decodable {
    public static func from(url: URL) throws -> BuildConfiguration {
        let data = try Data(contentsOf: url)
        return try PropertyListDecoder().decode(BuildConfiguration.self, from: data)
    }
    
    public let target: String
    public let stages: [String: String]
}
