import ComposableArchitecture
import DesignComponent
import SwiftUI

extension QueryResultView {
  struct GridView: View {
    @Bindable
    var store: StoreOf<QueryFeature>
    
    let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 0),
      GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
      GeometryReader { proxy in
        ScrollView {
          LazyVGrid(columns: columns, spacing: 0) {
            ForEach(store.displayingCards) { item in
              AmbientWebImage(url: item.getImageURL(type: .normal), placeholderName: "mtgBack")
                .frame(minWidth: (proxy.size.width)/2)
                .redacted(reason: store.redactionReason)
            }
          }
        }
      }
    }
  }
}
