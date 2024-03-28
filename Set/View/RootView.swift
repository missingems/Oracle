import ComposableArchitecture
import ScryfallKit
import SwiftUI

public struct RootView: View {
  private let networkEffect = NetworkEffect(client: ScryfallClient(networkLogLevel: .minimal))
  private let state = Feature.State()
  private let viewModel = RootViewModel()
  
  public init() {}
  
  public var body: some View {
    SetListView(
      viewModel: SetListViewModel(
        store: Store(initialState: state) {
          Feature(
            fetchSets: networkEffect.fetchSets,
            fetchCards: networkEffect.fetchCards(_:_:)
          )
        }
      )
    )
#if os(macOS)
    .toolbar { Text(viewModel.title) }
#elseif os(iOS)
    .tabItem { Label(viewModel.title, systemImage: viewModel.tabItemImageName) }
#endif
  }
}
