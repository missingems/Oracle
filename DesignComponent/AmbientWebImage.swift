import SDWebImageSwiftUI
import SwiftUI

public struct AmbientWebImage: View {
  public let url: URL?
  private let cornerRadius: CGFloat
  private let blurRadius: CGFloat
  private let offset: CGPoint
  private let scale: CGSize
  
  public init(
    url: URL? = nil,
    cornerRadius: CGFloat = 9,
    blurRadius: CGFloat = 13,
    offset: CGPoint = CGPoint(x: 0, y: 3),
    scale: CGSize = CGSize(width: 1, height: 1)
  ) {
    self.url = url
    self.cornerRadius = cornerRadius
    self.blurRadius = blurRadius
    self.offset = offset
    self.scale = scale
  }
  
  public var body: some View {
    ZStack {
      WebImage(url: url)
        .resizable()
        .blur(radius: blurRadius, opaque: false)
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .opacity(0.38)
        .scaleEffect(scale)
        .offset(x: offset.x, y: offset.y)
      
      WebImage(url: url)
        .resizable()
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color(.separator), lineWidth: 1 / Main.nativeScale).opacity(0.618))
    }
  }
}

