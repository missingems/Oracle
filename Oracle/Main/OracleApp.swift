import SwiftUI
import GameSet
import DesignComponent

@main
struct OracleApp: App {
  init() {
    DesignComponent.Main.setupSVGCoder()
  }
  
  var body: some Scene {
    WindowGroup {
      #if os(iOS)
      TabView {
        RootView()
        Text("Search").tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        Text("Game").tabItem {
          Label("Game", systemImage: "dice")
        }
        
        Text("Collection").tabItem {
          Label("Collection", systemImage: "archivebox")
        }
        
        Text("Profile").tabItem {
          Label("Profile", systemImage: "person.crop.circle")
        }
      }
      #else
      RootView()
      #endif
    }
  }
}
