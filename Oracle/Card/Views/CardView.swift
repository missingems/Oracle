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
  
  private let imageContainerView = UIView()
  private let imageView = UIImageView()
  private let foilView = FoilEffectView(frame: .zero)
  private let priceCapsuleLabel = InsetLabel(UIEdgeInsets(top: 3, left: 6, bottom: 3, right: 6))
  private let priceContainerView = UIView()
  private lazy var loadingIndicator = UIActivityIndicatorView(style: .medium)
  private lazy var flipButton = UIButton(type: .system)
  private let flipContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
  private var selectedFace: Card.Face?
  private var card: Card?
  var didTappedTransform: (() -> ())?
  
  init() {
    super.init(frame: .zero)
    
    let stackView = UIStackView(arrangedSubviews: [
      imageContainerView,
      priceContainerView,
    ])
    addSubview(stackView)
    stackView.spacing = 5
    stackView.axis = .vertical
    stackView.edgeAnchors == edgeAnchors
    
    imageContainerView.addSubview(imageView)
    imageView.edgeAnchors == imageContainerView.edgeAnchors
    imageContainerView.heightAnchor == imageContainerView.widthAnchor * 1.3928
    imageContainerView.horizontalAnchors == stackView.horizontalAnchors
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
    
    flipContainerView.contentView.addSubview(flipButton)
    flipButton.edgeAnchors == flipContainerView.contentView.edgeAnchors
    flipButton.setImage(UIImage(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill"), for: .normal)
    addSubview(flipContainerView)
    flipContainerView.sizeAnchors == CGSize(width: 44, height: 44)
    flipContainerView.centerXAnchor == trailingAnchor - 25
    flipContainerView.centerYAnchor == imageContainerView.centerYAnchor - 22
    flipContainerView.layer.cornerRadius = 22
    flipContainerView.clipsToBounds = true
    flipContainerView.layer.cornerCurve = .circular
    flipContainerView.layer.borderWidth = 1 / UIScreen.main.nativeScale
    flipContainerView.layer.borderColor = UIColor.separator.cgColor
    flipContainerView.isHidden = true
    flipButton.addTarget(self, action: #selector(flipButtonTapped), for: .touchUpInside)
  }
  
  @objc
  private func flipButtonTapped() {
    didTappedTransform?()
    
    var flipRight = true
    if selectedFace == card?.cardFaces?.first {
      selectedFace = card?.cardFaces?.last
    } else {
      selectedFace = card?.cardFaces?.first
      flipRight = false
    }
    
    guard let uri = selectedFace?.imageUris?.normal, let url = URL(string: uri) else {
      return
    }
    
    UIView.transition(
      with: imageContainerView,
      duration: 0.315,
      options: flipRight ? .transitionFlipFromRight : .transitionFlipFromLeft
    ) {
      self.imageView.setAsyncImage(url, placeholder: .mtgBack)
    }
  }
  
  func configure(
    _ card: Card,
    imageType: Card.ImageType,
    size: CardView.Size,
    showPrice: Bool,
    completion: ((UIImage?) -> ())? = nil
  ) {
    self.card = card
    self.selectedFace = card.cardFaces?.first
    loadingIndicator.startAnimating()
    
    let price = card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00"
    priceCapsuleLabel.text = "$\(price)"
    priceContainerView.isHidden = !showPrice
    priceCapsuleLabel.alpha = 1
    drawCornerRadius(size: size)
    
    switch card.layout {
    case .transform, .modalDfc, .reversibleCard:
      flipContainerView.isHidden = false
      
    default:
      flipContainerView.isHidden = true
    }
    
    imageView.setAsyncImage(card.getImageURL(type: imageType), placeholder: .mtgBack, onComplete: completion)
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
