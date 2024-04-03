import SDWebImageSwiftUI
import SwiftUI

public struct AmbientWebImage: View {
  public let url: URL?
  public let placeholderName: String
  private let cornerRadius: CGFloat
  
  public init(url: URL?, placeholderName: String, cornerRadius: CGFloat = 9) {
    self.url = url
    self.placeholderName = placeholderName
    self.cornerRadius = cornerRadius
  }
  
  public var body: some View {
    ZStack {
      WebImage(url: url) { image in
        image.resizable().blur(radius: 44, opaque: false)
      } placeholder: {
        Image(placeholderName, bundle: .main).resizable().clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
      }
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
      .opacity(0.38)
      .scaleEffect(CGSize(width: 1.1, height: 1.1))
      .offset(x: 0, y: 10)
      
      WebImage(url: url) { image in
        image.resizable()
      } placeholder: {
        Image(placeholderName, bundle: .main).resizable().clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
      }
      .scaledToFit()
      .aspectRatio(contentMode: .fit)
      .clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
      .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(.separator).opacity(0.618))
    }
  }
}
