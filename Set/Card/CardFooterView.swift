import DesignComponent
import SwiftUI

extension CardView {
  @ViewBuilder
  var footerView: some View {
    SectionView {
      ForEach(store.state.footerConfigurations.indices, id: \.self) { index in
        let configuration = store.state.footerConfigurations[index]
        
        if index != 0 {
          Divider().padding(.leading, 16.0)
        }
        
        NavigationLink {
          Text("Hello")
        } label: {
          SelectionRow(
            icon: configuration.iconName.map { DesignComponent.SelectionRow.Icon.custom(name: $0) } ?? .system(name: configuration.systemIconName),
            title: configuration.title,
            detail: configuration.detail
          )
        }
        .padding(.horizontal, 16.0)
      }
    }
  }
}
