import SDWebImageSVGNativeCoder

public struct Main {
  public static func setupSVGCoder() {
    let SVGCoder = SDImageSVGNativeCoder.shared
    SDImageCodersManager.shared.addCoder(SVGCoder)
  }
}
