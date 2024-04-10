import Nuke
import NukeUI
import SwiftUI
import Shimmer

struct RotationImageProcessor: ImageProcessing {
  func process(_ image: Nuke.PlatformImage) -> Nuke.PlatformImage? {
    return rotate(image: image, degrees: degrees)
  }
  
  var identifier = "com.missingems.mooligan.rotationImageProcessor"
  private let degrees: CGFloat
  
  public init(degrees: CGFloat) {
    self.degrees = degrees
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
  private let transformers: [ImageProcessing]
  
  public init(
    url: [URL?] = [],
    cornerRadius: CGFloat = 9,
    blurRadius: CGFloat = 13,
    offset: CGPoint = CGPoint(x: 0, y: 3),
    scale: CGSize = CGSize(width: 1, height: 1),
    rotation: CGFloat = 0,
    cycle: Cycle = Cycle(max: 1),
    width: CGFloat? = nil
  ) {
    self.url = url
    self.cornerRadius = cornerRadius
    self.blurRadius = blurRadius
    self.offset = offset
    self.scale = scale
    self.cycle = cycle
    
    var transformers: [ImageProcessing] = []
    
    if rotation != 0 {
      transformers.append(RotationImageProcessor(degrees: rotation))
    }
    
    if let width {
      transformers.append(.resize(width: width))
    }
    
    self.transformers = transformers
  }
  
  public var body: some View {
    if url.isEmpty == false {
      ZStack {
        LazyImage(
          request: ImageRequest(
            url: url[cycle.current],
            processors: transformers
          )
        ) { state in
          if let image = state.image {
            image.resizable().aspectRatio(contentMode: .fit)
          }
        }
        .blur(radius: blurRadius, opaque: false)
        .opacity(0.38)
        .scaleEffect(scale)
        .offset(x: offset.x, y: offset.y)
        
        LazyImage(
          request: ImageRequest(
            url: url[cycle.current],
            processors: transformers
          )
        ) { state in
          if state.isLoading {
            RoundedRectangle(cornerRadius: cornerRadius).fill(Color(.systemFill)).shimmering(
              gradient: Gradient(
                colors: [.black.opacity(0.8), .black.opacity(1), .black.opacity(0.8)]
              )
            )
          } else if let image = state.image {
            image.resizable().aspectRatio(contentMode: .fit)
          }
        }
        .clipShape(
          .rect(
            cornerRadii: .init(
              topLeading: cornerRadius,
              bottomLeading: cornerRadius,
              bottomTrailing: cornerRadius,
              topTrailing: cornerRadius
            )
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color(.separator), lineWidth: 1 / Main.nativeScale)
            .opacity(0.618)
        )
      }
    }
  }
}
