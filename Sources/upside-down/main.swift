import Darwin
import UpsideDownCLICore

do {
    try CommandLineTool.upsideDown.run(arguments: CommandLine.arguments)
    exit(0)
} catch let error as CLIError {
    print(error.localizedDescription)
    exit(error.exitCode)
} catch {
    print(error.localizedDescription)
    exit(1)
}
