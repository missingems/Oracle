import SDWebImageSwiftUI
import SwiftUI

public struct Cycle {
  let max: Int
  private(set) var current: Int
  
  public init(max: Int) {
    self.max = max
    current = 0
  }
  
  public mutating func next() {
    var _current = current
    _current += 1
    
    if _current >= max {
      _current = 0
    }
    
    self.current = _current
  }
}

public struct AmbientWebImage: View {
  public let url: [URL?]
  private let cornerRadius: CGFloat
  private let blurRadius: CGFloat
  private let offset: CGPoint
  private let scale: CGSize
  private var cycle: Cycle
  private var selectedURL: URL?
  
  public init(
    url: [URL?] = [],
    cornerRadius: CGFloat = 9,
    blurRadius: CGFloat = 13,
    offset: CGPoint = CGPoint(x: 0, y: 3),
    scale: CGSize = CGSize(width: 1, height: 1),
    cycle: Cycle = Cycle(max: 1)
  ) {
    self.url = url
    self.cornerRadius = cornerRadius
    self.blurRadius = blurRadius
    self.offset = offset
    self.scale = scale
    self.cycle = cycle
  }
  
  public var body: some View {
    ZStack {
      WebImage(url: url[cycle.current])
        .resizable()
        .blur(radius: blurRadius, opaque: false)
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .opacity(0.38)
        .scaleEffect(scale)
        .offset(x: offset.x, y: offset.y)
      
      WebImage(url: url[cycle.current])
        .resizable()
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color(.separator), lineWidth: 1 / Main.nativeScale).opacity(0.618))
    }
  }
}

