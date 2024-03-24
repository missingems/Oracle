import SDWebImageSwiftUI
import SwiftUI

public struct IconWebImage: View {
  private let url: URL
  
  public init(_ url: URL) {
    self.url = url
  }
  
  public var body: some View {
    WebImage(
      url: url,
      options: [.refreshCached],
      context: [
        .imageThumbnailPixelSize: CGSize(width: 30 * UIScreen.main.nativeScale, height: 30 * UIScreen.main.nativeScale),
        .imagePreserveAspectRatio: true
      ]
    )
    .resizable()
    .renderingMode(.template)
    .indicator(.activity)
    .foregroundStyle(Color.accentColor)
    .frame(width: 30, height: 30, alignment: .center)
  }
}
