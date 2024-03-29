import ScryfallKit
import SwiftUI

struct SetView: View {
  var viewModel: SetViewModel
  
  public var body: some View {
    NavigationStack(path: viewModel.$store.scope(state: \.path, action: \.path)) {
      List(viewModel.store.loadingState.data.indices, id: \.self) { index in
        SetListRow(
          viewModel: SetListRowViewModel(
            set: viewModel.store.loadingState.data[index],
            index: index
          )
        )
        .redacted(reason: viewModel.redactionReason)
        .overlay {
          NavigationLink(state: Feature.Path.State.selectSet) {
            EmptyView()
          }
          .opacity(0)
        }
      }
      .scrollDisabled(viewModel.store.loadingState == .isLoading)
      .navigationTitle(viewModel.title)
      .listStyle(.plain)
    } destination: { store in
      switch store.state {
      case .selectSet:
        QueryResultView()
      }
    }
    .tabItem {
      Label(viewModel.title, systemImage: viewModel.tabItemImageName)
    }
    .onAppear {
      viewModel.store.send(.fetchSets)
    }
  }
}
