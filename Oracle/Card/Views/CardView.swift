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
  enum ImageType {
    case small
    case regular
    case large
  }
  
  private let imageView = UIImageView()
  private let foilView = FoilEffectView(frame: .zero)
  private let priceCapsuleLabel = InsetLabel(UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6))
  private let priceContainerView = UIView()
  private let type: ImageType
  
  init(type: ImageType) {
    self.type = type
    super.init(frame: .zero)
    
    let stackView = UIStackView(arrangedSubviews: [
      imageView,
      priceContainerView,
    ])
    addSubview(stackView)
    stackView.spacing = 5
    stackView.axis = .vertical
    stackView.edgeAnchors == edgeAnchors
    
    imageView.heightAnchor == imageView.widthAnchor * 1.3928
    imageView.horizontalAnchors == stackView.horizontalAnchors
    imageView.layer.cornerRadius = 9.0
    imageView.layer.cornerCurve = .continuous
    imageView.clipsToBounds = true
    
    let priceView = UIView()
    priceView.addSubview(priceCapsuleLabel)
    priceView.layer.shadowColor = UIColor.black.cgColor
    priceView.layer.shadowRadius = 5
    priceView.layer.shadowOffset = CGSize(width: 0, height: 5)
    priceView.layer.shadowOpacity = 0.1
    priceView.clipsToBounds = false
    
    priceCapsuleLabel.heightAnchor == 21
    priceCapsuleLabel.edgeAnchors == priceView.edgeAnchors
    priceCapsuleLabel.textAlignment = .center
    priceCapsuleLabel.layer.cornerCurve = .continuous
    priceCapsuleLabel.layer.cornerRadius = 8
    priceCapsuleLabel.clipsToBounds = true
    priceCapsuleLabel.font = .monospacedDigitSystemFont(ofSize: 13.0, weight: .semibold)
    priceCapsuleLabel.backgroundColor = .capsule
    priceCapsuleLabel.textColor = .label
    
    priceContainerView.addSubview(priceView)
    priceView.centerXAnchor == priceContainerView.centerXAnchor
    priceView.verticalAnchors == priceContainerView.verticalAnchors
    
    if type != .regular {
      priceContainerView.isHidden = true
    } else {
      priceContainerView.isHidden = false
    }
  }
  
  func configure(_ card: Card, imageType: Card.ImageType, completion: ((UIImage?) -> ())? = nil) {
    imageView.sd_imageTransition = .fade(duration: 0.15)
    imageView.contentMode = .scaleAspectFit
    imageView.sd_setImage(
      with: card.getImageURL(type: imageType),
      placeholderImage: .mtgBack
    ) { image, _, _, _ in
      completion?(image)
    }
    
    let price = card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00"
    priceCapsuleLabel.text = "$\(price)"
    
    if type == .regular {
      priceContainerView.alpha = 1
    }
  }
  
  func setPlaceholder() {
    imageView.image = .mtgBack
    priceContainerView.alpha = 0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
