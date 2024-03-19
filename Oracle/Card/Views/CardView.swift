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
  private lazy var flipButton = UIButton(type: .system)
  private let flipContainerView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
  private var shouldFlipFromRight = false
  private var cardLayout: Card.Layout?

  var didTappedTransform: ((_ shouldFlipFromRight: Bool) -> ())?
  
  init(layout: Card.Layout? = nil) {
    self.cardLayout = layout
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
    
    if layout == .split {
      imageContainerView.heightAnchor == imageContainerView.widthAnchor / 1.3928
    } else {
      imageContainerView.heightAnchor == imageContainerView.widthAnchor * 1.3928
    }
    
    imageContainerView.horizontalAnchors == stackView.horizontalAnchors
    
    imageView.layer.cornerCurve = .continuous
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    
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
    
    priceContainerView.addSubview(priceView)
    priceView.centerXAnchor == priceContainerView.centerXAnchor
    priceView.verticalAnchors == priceContainerView.verticalAnchors
    priceCapsuleLabel.alpha = 0
    
    imageView.layer.borderWidth = 1 / UIScreen.main.nativeScale
    imageView.layer.borderColor = UIColor.separator.cgColor
    
    flipContainerView.contentView.addSubview(flipButton)
    flipButton.edgeAnchors == flipContainerView.contentView.edgeAnchors
    addSubview(flipContainerView)
    flipContainerView.sizeAnchors == CGSize(width: 44, height: 44)
    flipContainerView.centerXAnchor == trailingAnchor - 27
    flipContainerView.centerYAnchor == imageContainerView.centerYAnchor - 11
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
    shouldFlipFromRight.toggle()
    didTappedTransform?(shouldFlipFromRight)
    
    if cardLayout == .flip {
      imageContainerView.animateRotate(to: shouldFlipFromRight ? .degrees(180) : .identity)
    } else {
      imageContainerView.animateFlip(options: shouldFlipFromRight ? .transitionFlipFromRight : .transitionFlipFromLeft)
    }  
  }
  
  func configure(
    imageURL: URL?,
    imageType: Card.ImageType,
    size: CardView.Size,
    price: String?,
    layout: Card.Layout,
    completion: ((UIImage?) -> ())? = nil
  ) {
    cardLayout = layout
    
    if let price {
      priceCapsuleLabel.text = "$\(price)"
    }
    
    priceCapsuleLabel.alpha = 1
    priceContainerView.isHidden = price == nil
    drawCornerRadius(size: size)
    
    switch layout {
    case .transform, .modalDfc, .reversibleCard:
      flipButton.setImage(UIImage(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill"), for: .normal)
      flipContainerView.isHidden = false
      
    case .flip:
      flipButton.setImage(UIImage(systemName: "rotate.right"), for: .normal)
      flipContainerView.isHidden = false
      
    default:
      flipContainerView.isHidden = true
    }
    
    imageView.setAsyncImage(imageURL, placeholder: .mtgBack) { [weak self] image in
      guard let image = image, let cgImage = image.cgImage, layout == .split, size == .large else {
        completion?(image)
        return
      }
      
      let rotatedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
      self?.imageView.image = rotatedImage
      completion?(rotatedImage)
    }
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
