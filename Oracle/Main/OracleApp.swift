import SwiftUI
import `Set`
import DesignComponent

@main
struct OracleApp: App {
  typealias GameSet = `Set`
  
  init() {
    DesignComponent.Main.setupSVGCoder()
  }
  
  var body: some Scene {
    WindowGroup {
      #if os(iOS)
      TabView {
        RootView()
      }
      #else
      RootView()
      #endif
    }
  }
}
