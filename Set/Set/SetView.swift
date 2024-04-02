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
            }
            .disabled(viewModel.isInteractivable)
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
        
      case .showCard:
        if let store = store.scope(state: \.showCard, action: \.showCard) {
          CardView(store: store)
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
