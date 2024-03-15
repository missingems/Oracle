//
//  UIImageView+Extensions.swift
//  Oracle
//
//  Created by Jun on 15/3/24.
//

import UIKit
import SDWebImage

extension UIImageView {
  func setAsyncImage(_ url: URL?, placeholder: UIImage? = nil, context: [SDWebImageContextOption: Any]? = nil, shouldRenderTemplate: Bool = false, onComplete: ((UIImage?) -> ())? = nil) {
    sd_imageTransition = .fade(duration: 0.13)
    
    sd_setImage(
      with: url,
      placeholderImage: placeholder,
      options: [.refreshCached, .retryFailed, .avoidAutoSetImage, .avoidAutoCancelImage],
      context: context,
      progress: nil
    ) { [weak self] image, error, cache, url in
      self?.image = image
      onComplete?(image)
    }
  }
}
