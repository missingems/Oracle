import ComposableArchitecture
import ScryfallKit
import SwiftUI

public struct RootView: View {
  private let networkEffect = NetworkEffect(client: ScryfallClient(networkLogLevel: .minimal))
  private let state = Feature.State()
  
  public init() {}
  
  public var body: some View {
    NavigationView {
      SetListView(
        viewModel: SetListViewModel(
          store: Store(initialState: state) {
            Feature { try await networkEffect.fetchSets() }
          }
        )
      )
      .navigationTitle(state.title)
    }.tabItem {
      Label(state.title, systemImage: state.tabItemImageName)
    }
  }
}
