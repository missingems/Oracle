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
      )
    }
    .environment(\.defaultMinListRowHeight, 0)
    .listStyle(.plain)
  }
}
