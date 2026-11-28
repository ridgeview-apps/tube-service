import Foundation
import PackagePlugin

@main
struct BuildBusStopDatabase: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let sql = context.package.directoryURL.appending(path: "Seed/londonBusStops.sql")
        let database = context.pluginWorkDirectoryURL.appending(path: "londonBusStops.sqlite")
        return [
            .buildCommand(
                displayName: "Build londonBusStops.sqlite",
                executable: URL(filePath: "/bin/sh"),
                // sqlite3 appends to an existing database rather than replacing it
                arguments: ["-c", "rm -f \"$1\" && /usr/bin/sqlite3 \"$1\" < \"$2\"", "sh", database.path, sql.path],
                inputFiles: [sql],
                outputFiles: [database]
            )
        ]
    }
}
