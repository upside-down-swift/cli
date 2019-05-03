import Darwin
import UpsideDownCLICore

do {
    try CommandLineTool.upsideDown.run(arguments: CommandLine.arguments)
    exit(0)
} catch {
    print(error)
    exit(1)
}
