import SwiftUI
import SDWebImageSVGNativeCoder
import SDWebImage
import `Set`

@main
struct OracleApp: App {
  typealias GameSet = `Set`
  
  init() {
    let SVGCoder = SDImageSVGNativeCoder.shared
    SDImageCodersManager.shared.addCoder(SVGCoder)
  }
  
  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}
