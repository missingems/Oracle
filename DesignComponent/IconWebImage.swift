import SDWebImageSwiftUI
import SwiftUI

#if os(iOS)
import UIKit
let nativeScale = UIScreen.main.nativeScale
#elseif os(macOS)
import AppKit
let nativeScale = NSScreen.main?.backingScaleFactor ?? 1.0
#endif

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
          .imageThumbnailPixelSize: CGSize(width: 30 * nativeScale, height: 30 * nativeScale),
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
