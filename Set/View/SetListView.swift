import SwiftUI

struct SetListView: View {
  var viewModel: SetListViewModel
  
  public var body: some View {
    List(viewModel.store.sets.indices, id: \.self) { index in
      SetListRow(
        viewModel: SetListRowViewModel(
          set: viewModel.store.sets[index],
          index: index
        )
      )
    }
#if os(iOS)
    .listStyle(.plain)
#elseif os(macOS)
    .listStyle(.sidebar)
#endif
  }
}
