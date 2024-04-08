import NukeUI
import SDWebImageSwiftUI
import SwiftUI
import Kingfisher

struct CustomRotationImageProcessor: ImageProcessor {
  // The identifier should be unique to your processor.
  let identifier: String = "com.yourdomain.CustomRotationImageProcessor"
  let degrees: CGFloat
  
  init(degrees: CGFloat) {
    self.degrees = degrees
  }
  
  func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
    switch item {
    case let .image(value):
      return value
      
    case let .data(value):
      return rotate(image: UIImage(data: value)!, degrees: degrees)
    }
  }
  
  private func rotate(image: UIImage, degrees: CGFloat) -> UIImage? {
    guard image.cgImage != nil else { return nil }
    
    let radians = degrees * CGFloat.pi / 180
    let rotatedSize = CGRect(origin: .zero, size: image.size)
      .applying(CGAffineTransform(rotationAngle: radians))
      .integral.size
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, false, image.scale)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    
    context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    context.rotate(by: radians)
    
    image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
    
    let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return rotatedImage
  }
}

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
  private let rotation: CGFloat
  
  public init(
    url: [URL?] = [],
    cornerRadius: CGFloat = 9,
    blurRadius: CGFloat = 13,
    offset: CGPoint = CGPoint(x: 0, y: 3),
    scale: CGSize = CGSize(width: 1, height: 1),
    rotation: CGFloat = 0,
    cycle: Cycle = Cycle(max: 1)
  ) {
    self.url = url
    self.cornerRadius = cornerRadius
    self.blurRadius = blurRadius
    self.offset = offset
    self.scale = scale
    self.cycle = cycle
    self.rotation = rotation
  }
  
  public var body: some View {
    ZStack {
      KFImage(url[cycle.current])
        .setProcessor(CustomRotationImageProcessor(degrees: rotation))
        .resizable()
        .blur(radius: blurRadius, opaque: false)
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .opacity(0.38)
        .scaleEffect(scale)
        .offset(x: offset.x, y: offset.y)
      
      KFImage(url[cycle.current])
        .setProcessor(CustomRotationImageProcessor(degrees: rotation))
        .resizable()
        .scaledToFit()
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadii: .init(topLeading: cornerRadius, bottomLeading: cornerRadius, bottomTrailing: cornerRadius, topTrailing: cornerRadius)))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color(.separator), lineWidth: 1 / Main.nativeScale).opacity(0.618))
    }
  }
}

