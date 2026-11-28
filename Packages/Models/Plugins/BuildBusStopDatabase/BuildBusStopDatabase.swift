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
                executable: URL(filePath: "/usr/bin/sqlite3"),
                arguments: ["-bail", ":memory:", ".open --new \"\(database.path)\"", ".read \"\(sql.path)\""],
                inputFiles: [sql],
                outputFiles: [database]
            )
        ]
    }
}
