import ScryfallKit
import SwiftUI

struct QueryResultView: View {
  let viewModel: QueryResultViewModel
  
  var body: some View {
    Text("Query").onAppear {
      viewModel.store.send(.fetchCards(viewModel.selectedSet))
    }
  }
}
