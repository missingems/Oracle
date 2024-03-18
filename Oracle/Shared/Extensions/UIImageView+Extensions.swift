//
//  UIImageView+Extensions.swift
//  Oracle
//
//  Created by Jun on 15/3/24.
//

import UIKit
import SDWebImage
import Kingfisher

extension UIImageView {
  func setAsyncImage(_ url: URL?, placeholder: UIImage? = nil, onComplete: ((UIImage?) -> ())? = nil) {
    kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.135))]) { result in
      switch result {
      case let .success(imageResult):
        onComplete?(imageResult.image)
        
      case .failure:
        onComplete?(nil)
      }
    }
  }
  
  func setSVGImage(_ url: URL?) {
    sd_setImage(
      with: url,
      placeholderImage: nil,
      options: [.refreshCached, .retryFailed, .avoidAutoSetImage],
      context: [
        .imageThumbnailPixelSize : CGSize(width: 30 * UIScreen.main.nativeScale, height: 30 * UIScreen.main.nativeScale),
        .imagePreserveAspectRatio : true
      ],
      progress: nil,
      completed: { [weak self] image, error, cache, url in
        self?.image = image?.withRenderingMode(.alwaysTemplate)
      }
    )
  }
}
