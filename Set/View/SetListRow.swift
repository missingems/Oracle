import DesignComponent
import SwiftUI

struct SetListRow: View {
  let viewModel: SetListRowViewModel
  
  var body: some View {
    HStack(spacing: 11.0) {
      childIndicatorImage
      iconImage
      
      VStack(alignment: .leading, spacing: 3.0) {
        titleLabel
        
        HStack(spacing: 3.0) {
          setCodeLabel
          numberOfCardsLabel
        }
      }
      
      Spacer()
      disclosureIndicator
    }
#if os(iOS)
    .padding(11.0)
    .background { viewModel.shouldSetBackground ? Color.quaternarySystemFill : Color.clear }
    .listRowInsets(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
    .listRowSeparator(.hidden)
    .clipShape(.buttonBorder)
#endif
  }
}

// MARK: - UI Properties

extension SetListRow {
  private var childIndicatorImage: some View {
    Container(predicate: viewModel.isSetParent) {
      Image(systemName: viewModel.childIndicatorImageName)
        .foregroundColor(.tertiaryLabel)
        .imageScale(.small)
        .frame(width: 30, height: 30, alignment: .trailing)
    }
  }
  
  private var iconImage: some View {
    IconWebImage(viewModel.iconUrl)
  }
  
  private var titleLabel: some View {
    Text(viewModel.title)
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
