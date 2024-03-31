import ComposableArchitecture
import DesignComponent
import SwiftUI

extension QueryResultView {
  struct GridView: View {
    @Bindable
    var store: StoreOf<QueryFeature>
    
    let columns: [GridItem] = [
      GridItem(.flexible(), spacing: 5),
      GridItem(.flexible(), spacing: 5),
    ]
    
    var body: some View {
      GeometryReader { proxy in
        let itemWidth = (proxy.size.width - 15) / CGFloat(columns.count)
        let itemHeight = itemWidth * 1.3928
        
        ScrollView {
          LazyVGrid(columns: columns, spacing: 5) {
            ForEach(store.displayingCards.indices, id: \.self) { index in
              AmbientWebImage(url: store.displayingCards[index].getImageURL(type: .normal), placeholderName: "mtgBack")
                .frame(width: itemWidth, height: itemHeight)
                .redacted(reason: store.redactionReason)
                .onAppear { store.send(.loadMoreIfNeeded(index)) }
            }
          }.padding(.horizontal, 5.0)
        }
      }
    }
  }
}
