import SDWebImageSwiftUI
import SwiftUI

public struct IconWebImage: View {
  private let url: URL?
  
  public init(_ url: URL?) {
    self.url = url
  }
  
  public var body: some View {
    if let url {
      WebImage(
        url: url,
        options: [.refreshCached],
        context: [
          .imageThumbnailPixelSize: CGSize(width: 30 * Main.nativeScale, height: 30 * Main.nativeScale),
          .imagePreserveAspectRatio: true
        ]
      )
      .resizable()
      .renderingMode(.template)
      .indicator(.activity)
      .transition(.fade)
      .foregroundStyle(Color.accentColor)
      .frame(width: 30, height: 30, alignment: .center)
    } else {
      EmptyView()
    }
  }
}
