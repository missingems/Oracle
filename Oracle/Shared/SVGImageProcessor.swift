//
//  SVGImageProcessor.swift
//  Oracle
//
//  Created by Jun on 18/3/24.
//

import UIKit
import Kingfisher
import SVGKit

public struct SVGImgProcessor:ImageProcessor {
  public var identifier: String = "com.appidentifier.webpprocessor"
  public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
    switch item {
    case .image(let image):
      return image
      
    case .data(let data):
      let imsvg = SVGKImage(data: data)
      return imsvg?.uiImage
    }
  }
}
