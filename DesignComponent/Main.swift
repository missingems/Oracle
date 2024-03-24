import SDWebImageSVGNativeCoder

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct Main {
  #if os(iOS)
    static let nativeScale = UIScreen.main.nativeScale
  #elseif os(macOS)
    static let nativeScale = NSScreen.main?.backingScaleFactor ?? 1.0
  #else
    static let nativeScale = 3.0
  #endif
    
  public static func setupSVGCoder() {
    let SVGCoder = SDImageSVGNativeCoder.shared
    SDImageCodersManager.shared.addCoder(SVGCoder)
  }
}
