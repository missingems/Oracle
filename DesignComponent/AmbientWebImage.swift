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
      .aspectRatio(contentMode: .fit)
      .opacity(0.38)
      
      WebImage(url: url) { image in
        image.resizable()
      } placeholder: {
        Image(placeholderName, bundle: .main).resizable()
      }
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
      .clipShape(.rect(cornerRadii: .init(topLeading: 9, bottomLeading: 9, bottomTrailing: 9, topTrailing: 9)))
      .overlay(RoundedRectangle(cornerRadius: 9).stroke(.separator).opacity(0.618))
    }
  }
}
