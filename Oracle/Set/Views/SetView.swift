import SwiftUI

struct SetView: View {
  var body: some View {
    SetRow(
      viewModel: SetRow.ViewModel(
        code: "MH2",
        numberOfCards: "321 Cards",
        index: 0,
        title: "Diuleiloumou"
      )
    )
  }
}

#Preview {
  SetView()
}
