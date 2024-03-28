import ScryfallKit
import SwiftUI

struct SetListView: View {
  var viewModel: SetListViewModel
  
  public var body: some View {
#if os(iOS)
    NavigationStack {
      List(viewModel.store.loadingState.data.indices, id: \.self) { index in
        SetListRow(
          viewModel: SetListRowViewModel(
            set: viewModel.store.loadingState.data[index],
            index: index
          )
        )
        .redacted(reason: viewModel.store.loadingState == .isLoading ? .placeholder : .invalidated)
      }
      .navigationTitle(viewModel.title)
    }
    .listStyle(.plain)
#elseif os(macOS)
    .listStyle(.sidebar)
#endif
  }
}
