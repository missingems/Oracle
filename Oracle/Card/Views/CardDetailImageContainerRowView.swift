import UIKit
import Anchorage
import SDWebImage
import ScryfallKit

final class CardDetailImageContainerRowView: UIView {
  enum Action {
    case imageTapped
    case transformTapped
  }
  
  private lazy var cardImageView = CardView()
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
    cardImageView.horizontalAnchors == cardContainerView.horizontalAnchors + 56
    
    let stackView = UIStackView(arrangedSubviews: [.separator(fullWidth: true), cardContainerView])
    stackView.spacing = 21
    stackView.axis = .vertical
    addSubview(stackView)
    stackView.edgeAnchors == edgeAnchors
    
    cardBackdropImageView.widthAnchor == cardImageView.widthAnchor
    cardBackdropImageView.heightAnchor == cardImageView.heightAnchor
    cardBackdropImageView.topAnchor == topAnchor + 34
    cardBackdropImageView.horizontalAnchors == cardImageView.horizontalAnchors
    
    cardImageView.layer.cornerRadius = 15
    cardImageView.layer.cornerCurve = .continuous
    cardImageView.clipsToBounds = true
    
    let ratio: CGFloat = 936/672
    cardImageView.heightAnchor == cardImageView.widthAnchor * ratio
    
    preservesSuperviewLayoutMargins = true
    
    if card.cardFaces?.isEmpty == false {
      let button = UIButton(type: .system,
        primaryAction: UIAction(
          title: String(localized: "Transform"),
          image: UIImage(systemName: "rectangle.portrait.rotate")
        ) { _ in
          action(.transformTapped)
        }
      )
      button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
      stackView.addArrangedSubview(button)
    }
    
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
