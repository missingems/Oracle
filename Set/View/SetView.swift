import ScryfallKit
import SwiftUI

struct SetView: View {
  var viewModel: SetViewModel
  
  public var body: some View {
    NavigationStack(path: viewModel.$store.scope(state: \.path, action: \.path)) {
      List(viewModel.displayingSets.indices, id: \.self) { index in
        SetListRow(viewModel: viewModel.makeSetListRowViewModel(for: index))
          .redacted(reason: viewModel.redactionReason)
          .overlay {
            NavigationLink(state: viewModel.navigationState(at: index)) {
              EmptyView()
            }
            .opacity(0)
          }
      }
      .scrollDisabled(viewModel.isScrollEnabled)
      .navigationTitle(viewModel.title)
      .listStyle(.plain)
    } destination: {
      viewModel.navigate(with: $0)
    }
    .tabItem {
      Label(viewModel.title, systemImage: viewModel.tabItemImageName)
    }
    .onAppear {
      viewModel.store.send(.fetchSets)
    }
  }
}
