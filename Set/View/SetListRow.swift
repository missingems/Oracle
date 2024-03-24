import DesignComponent
import SwiftUI

struct SetListRow: View {
  let viewModel: SetListRowViewModel
  
  var body: some View {
    HStack {
      childIndicatorImage
      iconImage
      
      VStack(alignment: .leading, spacing: .smallSpacing) {
        titleLabel
        
        HStack(spacing: .smallSpacing) {
          setCodeLabel
          numberOfCardsLabel
        }
      }
      
      Spacer()
      disclosureIndicator
    }
    .padding(EdgeInsets(top: 13.0, leading: 13.0, bottom: 15.0, trailing: 13.0))
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

// MARK: - UI Properties

extension SetListRow {
  private var childIndicatorImage: some View {
    Container(predicate: viewModel.isParent) {
      Image(systemName: viewModel.childIndicatorImageName)
        .foregroundColor(Color(uiColor: .tertiaryLabel))
        .frame(minWidth: 30, minHeight: 30)
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
      .foregroundColor(Color(uiColor: .tertiaryLabel))
      .frame(minWidth: 20, minHeight: 20)
  }
}
