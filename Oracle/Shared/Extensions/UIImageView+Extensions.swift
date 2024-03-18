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
    kf.setImage(with: url, placeholder: placeholder) { result in
      switch result {
      case let .success(imageResult):
        onComplete?(imageResult.image)
        
      case .failure:
        onComplete?(nil)
      }
    }
  }
}
