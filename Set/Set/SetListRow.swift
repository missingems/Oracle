import DesignComponent
import SwiftUI

struct SetListRow: View {
  @GestureState
  private var isPressed = false
  
  let viewModel: SetListRowViewModel
  
  var body: some View {
    LazyVStack {
      HStack(spacing: 11.0) {
        childIndicatorImage.frame(width: 30, height: 30, alignment: .trailing)
        iconImage.frame(width: 30, height: 30, alignment: .center)
        
        VStack(alignment: .leading, spacing: 5.0) {
          titleLabel
          
          HStack(spacing: 5.0) {
            setCodeLabel
            numberOfCardsLabel
          }
        }
        
        Spacer()
        disclosureIndicator
      }
      .padding(EdgeInsets(top: 8, leading: 11, bottom: 11, trailing: 11))
      .background { viewModel.shouldSetBackground ? Color.quaternarySystemFill : Color.clear }
      .clipShape(.buttonBorder)
      .padding(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
    }
  }
}

// MARK: - UI Properties

extension SetListRow {
  private var childIndicatorImage: some View {
    Container(predicate: viewModel.isSetParent) {
      Image(systemName: viewModel.childIndicatorImageName)
        .foregroundColor(.tertiaryLabel)
        .imageScale(.small)
    }
  }
  
  private var iconImage: some View {
    IconWebImage(viewModel.iconUrl)
  }
  
  private var titleLabel: some View {
    Text(viewModel.title).lineLimit(2).multilineTextAlignment(.leading)
  }
  
  private var setCodeLabel: some View {
    PillText(viewModel.id).font(.caption).monospaced()
  }
  
  private var numberOfCardsLabel: some View {
    Text(viewModel.numberOfCardsLabel).font(.caption)
  }
  
  private var disclosureIndicator: some View {
    Image(systemName: viewModel.disclosureIndicatorImageName)
      .foregroundColor(.tertiaryLabel)
      .imageScale(.small)
  }
}
