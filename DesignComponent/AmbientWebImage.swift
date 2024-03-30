import SDWebImageSwiftUI
import SwiftUI

public struct AmbientWebImage: View {
  public let url: URL?
  public let placeholderName: String
  
  public init(url: URL?, placeholderName: String) {
    self.url = url
    self.placeholderName = placeholderName
  }
  
  public var body: some View {
    ZStack {
      WebImage(url: url) { image in
        image.resizable().blur(radius: 20, opaque: false)
      } placeholder: {
        Image(placeholderName, bundle: .main).resizable()
      }
      .scaledToFit()
      .padding(.top, 15)
      .aspectRatio(contentMode: .fit)
      .opacity(0.618)
      
      WebImage(url: url) { image in
        image.resizable()
      } placeholder: {
        Image(placeholderName, bundle: .main).resizable()
      }
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
      .clipShape(.rect(cornerRadii: .init(topLeading: 7, bottomLeading: 7, bottomTrailing: 7, topTrailing: 7)))
    }
  }
}
