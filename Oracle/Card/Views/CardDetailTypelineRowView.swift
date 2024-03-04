import UIKit
import Anchorage

final class CardDetailTypelineRowView: UIView {
  private lazy var titleLabel = UILabel()
  private lazy var iconImageView = UIImageView()
  
  init(title: String?, iconURI: String?) {
    super.init(frame: .zero)
    preservesSuperviewLayoutMargins = true
    
    titleLabel.font = .preferredFont(forTextStyle: .body)
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .left
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    iconImageView.tintColor = .accent
    
    let iconContainerView = UIView()
    iconContainerView.addSubview(iconImageView)
    iconImageView.horizontalAnchors == iconContainerView.horizontalAnchors
    iconImageView.centerYAnchor == iconContainerView.centerYAnchor
    iconImageView.sizeAnchors == CGSize(width: 21, height: 21)
    iconImageView.contentMode = .scaleAspectFit
    
    let titleDetailStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      UIView(),
      iconContainerView
    ])
    titleDetailStackView.preservesSuperviewLayoutMargins = true
    
    addSubview(titleDetailStackView)
    titleDetailStackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    titleDetailStackView.verticalAnchors == verticalAnchors + 11
    
    let separator = UIView.separator()
    addSubview(separator)
    separator.bottomAnchor == bottomAnchor
    separator.horizontalAnchors == horizontalAnchors
    
    configure(title: title, iconURI: iconURI)
  }
  
  func configure(title: String?, iconURI: String?) {
    guard let title, let iconURI, let url = URL(string: iconURI) else {
      isHidden = true
      return
    }
    
    isHidden = false
    titleLabel.text = title
    
    iconImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
      self?.iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
