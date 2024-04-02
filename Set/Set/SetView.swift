import ScryfallKit
import SwiftUI

struct SetView: View {
  var viewModel: SetViewModel
  
  public var body: some View {
    NavigationStack(path: viewModel.$store.scope(state: \.path, action: \.path)) {
      ScrollView {
        LazyVGrid(columns: [GridItem(spacing: 0, alignment: .leading)], spacing: 0) {
          ForEach(viewModel.displayingSets.indices, id: \.self) { index in
            NavigationLink(state: viewModel.navigationState(at: index)) {
              SetListRow(viewModel: viewModel.makeSetListRowViewModel(for: index))
                .redacted(reason: viewModel.redactionReason)
                .overlay {
                  NavigationLink(state: viewModel.navigationState(at: index)) {
                    EmptyView()
                  }
                  .opacity(0)
                }
            }
          }
        }
      }
      .navigationTitle(viewModel.title)
    } destination: { store in
      switch store.state {
      case .showQuery:
        if let store = store.scope(state: \.showQuery, action: \.showQuery) {
          QueryResultView(store: store)
        }
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
