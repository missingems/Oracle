import SwiftUI

struct SetRow: View {
  var viewModel: ViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(viewModel.title).font(.body)
      
      HStack {
        CodeView(code: viewModel.code)
        Text(viewModel.numberOfCards).font(.caption)
        Spacer()
      }
    }
    .padding(EdgeInsets(top: 13, leading: 13, bottom: 15, trailing: 13))
    .background { viewModel.backgroundColor }
    .clipShape(.buttonBorder)
    .padding(.horizontal, 20)
  }
}

extension SetRow {
  struct ViewModel: Equatable {
    private let index: Int
    
    let code: String
    let title: String
    let numberOfCards: String
    
    var backgroundColor: Color {
      index.hashValue.isMultiple(of: 2) ? Color(uiColor: .quaternarySystemFill) : .clear
    }
    
    init(
      code: String,
      numberOfCards: String,
      index: Int,
      title: String
    ) {
      self.code = code
      self.numberOfCards = numberOfCards
      self.index = index
      self.title = title
    }
  }
}
