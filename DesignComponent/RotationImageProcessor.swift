import SwiftUI
import Kingfisher

public struct RotationImageProcessor: ImageProcessor {
  public let identifier: String = "com.missingems.mooligan.CustomRotationImageProcessor"
  private let degrees: CGFloat
  
  public init(degrees: CGFloat) {
    self.degrees = degrees
  }
  
  public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
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
