//
//  CardView.swift
//  Oracle
//
//  Created by Jun on 3/3/24.
//

import Anchorage
import UIKit
import ScryfallKit

final class CardView: UIView {
  let imageView = UIImageView()
  let foilView = FoilEffectView(frame: .zero)
  
  init() {
    super.init(frame: .zero)
    addSubview(imageView)
    imageView.edgeAnchors == edgeAnchors
    imageView.layer.cornerRadius = 8.0
    imageView.layer.cornerCurve = .continuous
    imageView.clipsToBounds = true
  }
  
  func configure(_ card: Card, imageType: Card.ImageType, completion: ((UIImage?) -> ())? = nil) {
    imageView.sd_imageTransition = .fade(duration: 0.15)
    imageView.sd_setImage(
      with: card.getImageURL(type: imageType),
      placeholderImage: .mtgBack
    ) { image, _, _, _ in
      completion?(image)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
