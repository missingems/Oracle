import Anchorage
import UIKit

final class CardTitleDetailRowView: UIView {
  private lazy var titleLabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.numberOfLines = 0
    label.textAlignment = .left
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var manaCostLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.numberOfLines = 0
    label.textAlignment = .right
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    
    let titleDetailStackView = UIStackView(arrangedSubviews: [
      titleLabel,
      UIView(),
      manaCostLabel
    ])
    titleDetailStackView.preservesSuperviewLayoutMargins = true
    
    addSubview(titleDetailStackView)
    titleDetailStackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    preservesSuperviewLayoutMargins = true
    titleDetailStackView.verticalAnchors == verticalAnchors + 11
    
    let seperator = UIView.separator()
    addSubview(seperator)
    seperator.bottomAnchor == bottomAnchor
    seperator.horizontalAnchors == horizontalAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ title: String?, manaCost: NSAttributedString?) {
    titleLabel.text = title
    manaCostLabel.attributedText = manaCost
  }
}
