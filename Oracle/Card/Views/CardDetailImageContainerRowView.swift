import UIKit
import Anchorage
import SDWebImage
import ScryfallKit

final class CardDetailImageContainerRowView: UIView {
  enum Action {
    case imageTapped
    case transformTapped
  }
  
  private lazy var cardImageView = CardView(type: .large)
  private lazy var cardBackdropImageView = UIImageView()
  private let card: Card
  
  init(card: Card, action: @escaping (Action) -> ()) {
    self.card = card
    super.init(frame: .zero)
    addSubview(cardBackdropImageView)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    addSubview(visualEffectView)
    visualEffectView.edgeAnchors == edgeAnchors
    
    let cardContainerView = UIView()
    cardContainerView.addSubview(cardImageView)
    cardImageView.verticalAnchors == cardContainerView.verticalAnchors
    cardImageView.horizontalAnchors == cardContainerView.horizontalAnchors + 64
    
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
    stackView.addArrangedSubview(.separator(fullWidth: true))
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with imageURL: URL?) {
    cardImageView.configure(card, imageType: .normal) { [weak self] image in
      self?.cardBackdropImageView.image = image
    }
  }
}
