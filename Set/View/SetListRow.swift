import DesignComponent
import SwiftUI

struct SetListRow: View {
  let viewModel: SetListRowViewModel
  
  var body: some View {
    HStack {
      if viewModel.isParent == false {
        Image(systemName: "arrow.turn.down.right")
          .foregroundColor(Color(uiColor: .tertiaryLabel))
          .frame(minWidth: 30, minHeight: 30)
      }
      
      if let url = viewModel.iconUrl {
        IconWebImage(url)
      }
      
      VStack(alignment: .leading, spacing: Spacing.small.rawValue) {
        Text(viewModel.title)
        
        HStack(spacing: Spacing.small.rawValue) {
          PillText(viewModel.id).font(.caption).monospaced()
          Text(viewModel.numberOfCardsLabel).font(.caption)
        }
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundColor(Color(uiColor: .tertiaryLabel))
        .frame(minWidth: 20, minHeight: 20)
    }
    .padding(
      EdgeInsets(
        top: 13.0,
        leading: 13.0,
        bottom: 15.0,
        trailing: 13.0
      )
    )
    .background {
      if viewModel.shouldSetBackground {
        Color(uiColor: .quaternarySystemFill)
      } else {
        Color.clear
      }
    }
    .clipShape(.buttonBorder)
  }
}
