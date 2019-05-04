//
//  Path.swift
//  UpsideDownCLICore
//
//  Created by Marcus Smith on 5/4/19.
//

import Foundation

struct Path: Decodable {
    let rawValue: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let path = try container.decode(String.self)
        try self.init(path: path)
    }
    
    init(path: String) throws {
        var url: URL
        
        if path.hasPrefix("~") {
            url = URL(fileURLWithPath: NSString(string: path).expandingTildeInPath)
        } else {
            url = URL(fileURLWithPath: path)
        }
        
        if try Path.isAlias(url) {
            url = try URL(resolvingAliasFileAt: url)
        }
        
        rawValue = url
    }
    
    private static func isAlias(_ url: URL) throws -> Bool {
        let resourceValues = try url.resourceValues(forKeys: [.isAliasFileKey])
        return resourceValues.isAliasFile == true
    }
}
