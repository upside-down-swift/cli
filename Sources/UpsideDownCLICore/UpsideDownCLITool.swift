//
//  UpsideDownCLITool.swift
//
//  Created by Marcus Smith on 4/29/19.
//

import Foundation

extension CommandLineTool {
    public static let upsideDown = CommandLineTool(commands: ["build": BuildCommand.self], usage: "command [command options] [arguments...]", overview: "Command Line Interface for Upside Down applications")
}
