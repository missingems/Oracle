import ComposableArchitecture
import ScryfallKit
import SwiftUI

public struct RootView: View {
  private let client = ScryfallClient()
  private let state = Feature.State()
  
  public init() {}
  
  public var body: some View {
    SetView(
      store: Store(initialState: state) {
        Feature { try await client.getSets() }
      }
    )
  }
}
