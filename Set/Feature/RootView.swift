import ComposableArchitecture
import ScryfallKit
import SwiftUI

public struct RootView: View {
  private let networkEffect = NetworkEffect(client: ScryfallClient(networkLogLevel: .minimal))
  private let state = Feature.State()
  
  public init() {}
  
  public var body: some View {
    SetListView(
      viewModel: SetListViewModel(
        store: Store(initialState: state) {
          Feature { try await networkEffect.fetchSets() }
        }
      )
    )
#if os(macOS)
    .toolbar { Text(state.title) }
#elseif os(iOS)
    .navigationTitle(state.title)
#endif
  }
}
