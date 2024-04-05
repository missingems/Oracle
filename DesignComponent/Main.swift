import SDWebImage
import SDWebImageSVGNativeCoder

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct Main {
  #if os(iOS)
    public static let nativeScale = UIScreen.main.nativeScale
  #elseif os(macOS)
  public static let nativeScale = NSScreen.main?.backingScaleFactor ?? 1.0
  #else
  public static let nativeScale = 3.0
  #endif
    
  public static func setupSVGCoder() {
    let SVGCoder = SDImageSVGNativeCoder.shared
    SDImageCodersManager.shared.addCoder(SVGCoder)
    
    SDImageCache.shared.config.maxMemoryCost = 10000000 * 20 // 200mb
    SDImageCache.shared.config.maxDiskSize = 100000000 * 20 // 200mb
  }
}
