import ScryfallKit
import SwiftUI

struct SetListView: View {
  var viewModel: SetListViewModel
  
  public var body: some View {
#if os(iOS)
    NavigationStack(path: viewModel.$store.scope(state: \.path, action: \.path)) {
      List(viewModel.store.loadingState.data.indices, id: \.self) { index in
        SetListRow(
          viewModel: SetListRowViewModel(
            set: viewModel.store.loadingState.data[index],
            index: index
          )
        )
        .redacted(reason: viewModel.store.loadingState == .isLoading ? .placeholder : .invalidated)
        .overlay {
          NavigationLink(state: Feature.Path.State.selectSet) {
            EmptyView()
          }
          .opacity(0)
        }
#if os(iOS)
        .listRowInsets(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
        .listRowSeparator(.hidden)
#endif
      }
      .scrollDisabled(viewModel.store.loadingState == .isLoading)
      .navigationTitle(viewModel.title)
      .listStyle(.plain)
    } destination: { store in
      switch store.state {
      case .selectSet:
        Text("you did it")
      }
    }
    
#elseif os(macOS)
    .listStyle(.sidebar)
#endif
  }
}

