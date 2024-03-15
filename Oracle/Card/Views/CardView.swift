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
  enum Size {
    case small
    case regular
    case large
  }
  
  private let imageView = UIImageView()
  private let foilView = FoilEffectView(frame: .zero)
  private let priceCapsuleLabel = InsetLabel(UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6))
  private let priceContainerView = UIView()
  private lazy var loadingIndicator = UIActivityIndicatorView(style: .medium)
  
  init() {
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
    imageView.layer.cornerCurve = .continuous
    imageView.clipsToBounds = true
    
    let priceView = UIView()
    priceView.layer.shadowColor = UIColor.black.cgColor
    priceView.layer.shadowRadius = 5
    priceView.layer.shadowOffset = CGSize(width: 0, height: 5)
    priceView.layer.shadowOpacity = 0.1
    priceView.clipsToBounds = false
    
    priceView.addSubview(priceCapsuleLabel)
    priceCapsuleLabel.heightAnchor == 21
    priceCapsuleLabel.edgeAnchors == priceView.edgeAnchors
    priceCapsuleLabel.textAlignment = .center
    priceCapsuleLabel.layer.cornerCurve = .continuous
    priceCapsuleLabel.layer.cornerRadius = 9
    priceCapsuleLabel.clipsToBounds = true
    priceCapsuleLabel.font = .monospacedDigitSystemFont(ofSize: 13.0, weight: .medium)
    priceCapsuleLabel.backgroundColor = .capsule
    priceCapsuleLabel.textColor = .label
    
    priceContainerView.addSubview(loadingIndicator)
    loadingIndicator.centerAnchors == priceContainerView.centerAnchors
    loadingIndicator.startAnimating()
    
    priceContainerView.addSubview(priceView)
    priceView.centerXAnchor == priceContainerView.centerXAnchor
    priceView.verticalAnchors == priceContainerView.verticalAnchors
    priceCapsuleLabel.alpha = 0
    
    imageView.layer.borderWidth = 1 / UIScreen.main.nativeScale
    imageView.layer.borderColor = UIColor.separator.cgColor
  }
  
  func configure(
    _ card: Card,
    imageType: Card.ImageType,
    size: CardView.Size,
    showPrice: Bool,
    completion: ((UIImage?) -> ())? = nil
  ) {
    loadingIndicator.startAnimating()
    imageView.sd_imageTransition = .fade(duration: 0.15)
    imageView.sd_setImage(
      with: card.getImageURL(type: imageType),
      placeholderImage: .mtgBack
    ) { image, _, _, _ in
      completion?(image)
    }
    
    let price = card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00"
    priceCapsuleLabel.text = "$\(price)"
    priceContainerView.isHidden = !showPrice
    priceCapsuleLabel.alpha = 1
    drawCornerRadius(size: size)
  }
  
  func setPlaceholder(size: CardView.Size) {
    imageView.image = .mtgBack
    drawCornerRadius(size: size)
  }
  
  private func drawCornerRadius(size: Size) {
    switch size {
    case .large:
      imageView.layer.cornerRadius = 14
      
    case .regular:
      imageView.layer.cornerRadius = 9
      
    case .small:
      imageView.layer.cornerRadius = 9
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
