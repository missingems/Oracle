import SwiftUI

struct SetListView: View {
  var viewModel: SetListViewModel
  
  public var body: some View {
    List(viewModel.store.sets.indices, id: \.self) { index in
      SetListRow(
        viewModel: SetListRowViewModel(
          set: viewModel.store.sets[index],
          shouldSetBackground: viewModel.shouldSetBackgroundForRow(at: index)
        )
      ).listRowInsets(
        EdgeInsets(
          top: 0,
          leading: 16.0,
          bottom: 0,
          trailing: 16.0
        )
      )
      .listRowSeparator(.hidden)
    }
    .environment(\.defaultMinListRowHeight, 0)
    .listStyle(.plain)
  }
}
