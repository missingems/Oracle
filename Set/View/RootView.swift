import ComposableArchitecture
import ScryfallKit
import SwiftUI

public struct RootView: View {
  private let networkEffect = NetworkEffect(client: ScryfallClient(networkLogLevel: .minimal))
  
  public init() {}
  
  public var body: some View {
    SetView(
      viewModel: SetViewModel(
        store: Store(initialState: Feature.State()) {
          Feature(
            fetchSets: networkEffect.fetchSets,
            fetchCards: networkEffect.fetchCards(_:_:)
          )
        }
      )
    )
  }
}
