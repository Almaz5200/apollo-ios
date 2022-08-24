import Foundation
import PackagePlugin

@main struct CodegenPluginInitialize: CommandPlugin {
  func performCommand(context: PluginContext, arguments: [String]) async throws {
    let executableURL = context.codegenExecutable
  }
}
