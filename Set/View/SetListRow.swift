import DesignComponent
import SwiftUI

struct SetListRow: View {
  let viewModel: SetListRowViewModel
  
  var body: some View {
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
    .padding(11.0)
    .background { viewModel.shouldSetBackground ? Color.quaternarySystemFill : Color.clear }
    .clipShape(.buttonBorder)
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
    Text(viewModel.title).lineLimit(2)
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
