import UIKit
import Anchorage
import SDWebImage
import ScryfallKit

final class CardDetailImageContainerRowView: UIView {
  enum Action {
    case imageTapped
    case transformTapped
  }
  
  private lazy var cardImageView = CardView(card: card)
  private var card: Card
  private lazy var cardBackdropImageView = UIImageView()
  
  init(imageURL: URL?, card: Card, action: @escaping (Action) -> ()) {
    self.card = card
    super.init(frame: .zero)
    addSubview(cardBackdropImageView)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    addSubview(visualEffectView)
    visualEffectView.edgeAnchors == edgeAnchors
    
    let cardContainerView = UIView()
    cardContainerView.preservesSuperviewLayoutMargins = true
    cardContainerView.addSubview(cardImageView)
    cardImageView.verticalAnchors == cardContainerView.verticalAnchors
    
    if card.isLandscape == true {
      cardImageView.horizontalAnchors == cardContainerView.layoutMarginsGuide.horizontalAnchors
    } else {
      cardImageView.horizontalAnchors == cardContainerView.layoutMarginsGuide.horizontalAnchors + 44
    }
    
    let stackView = UIStackView(arrangedSubviews: [.separator(fullWidth: true), cardContainerView])
    stackView.spacing = 21
    stackView.axis = .vertical
    addSubview(stackView)
    stackView.edgeAnchors == edgeAnchors
    
    cardBackdropImageView.widthAnchor == cardImageView.widthAnchor
    cardBackdropImageView.heightAnchor == cardImageView.heightAnchor
    cardBackdropImageView.topAnchor == topAnchor + 34
    cardBackdropImageView.horizontalAnchors == cardImageView.horizontalAnchors
        
    preservesSuperviewLayoutMargins = true
    stackView.preservesSuperviewLayoutMargins = true
    stackView.addArrangedSubview(.separator(fullWidth: true))
    clipsToBounds = true
    
    cardImageView.didTappedTransform = { _ in
      action(.transformTapped)
    }
    
    configure(with: imageURL, card: card)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with imageURL: URL?, card: Card) {
    cardImageView.configure(
      imageURL: imageURL,
      imageType: .normal,
      size: .large,
      price: nil,
      card: card
    ) { [weak self] image in
      self?.cardBackdropImageView.image = image
    }
  }
}
