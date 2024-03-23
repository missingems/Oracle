import ComposableArchitecture
import ScryfallKit
import SwiftUI

@main
struct OracleApp: App {
  private let client = ScryfallClient(networkLogLevel: .minimal)
  
  var body: some Scene {
    WindowGroup {
      SetView(
        store: Store(initialState: SetFeature.State()) {
          SetFeature(
            setsFetcher: { try await client.getSets() }
          )
        }
      )
    }
  }
}
