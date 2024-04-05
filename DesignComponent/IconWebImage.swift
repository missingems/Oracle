import SDWebImageSwiftUI
import SwiftUI

public struct IconWebImage: View {
  private let url: URL?
  
  public init(_ url: URL?) {
    self.url = url
  }
  
  public var body: some View {
    if let url {
      WebImage(url: url)
      .resizable()
      .renderingMode(.template)
      .indicator(.activity)
      .aspectRatio(contentMode: .fit)
      .tint(Color.accentColor)
    }
  }
}
