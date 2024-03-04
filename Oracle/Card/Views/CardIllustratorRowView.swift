import Anchorage
import UIKit

final class CardIllustratorRowView: UIView {
  private let label: InsetLabel
  private let button: UIButton
  
  init(
    title: String?,
    buttonText: String?,
    _ onTapped: @escaping () -> ()
  ) {
    label = InsetLabel(UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0))
    
    button = UIButton(
      type: .system,
      primaryAction: UIAction { action in
        onTapped()
      }
    )
    button.titleLabel?.font = .preferredFont(forTextStyle: .body)
    
    super.init(frame: .zero)
    
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    let stackView = UIStackView(
      arrangedSubviews: [
        label,
        button,
        UIView()
      ]
    )
    
    stackView.spacing = 5
    addSubview(stackView)
    stackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    stackView.verticalAnchors == verticalAnchors
    stackView.preservesSuperviewLayoutMargins = true
    preservesSuperviewLayoutMargins = true
    
    let separator = UIView.separator()
    addSubview(separator)
    separator.horizontalAnchors == horizontalAnchors
    separator.bottomAnchor == bottomAnchor
    
    configure(title: title, buttonText: buttonText)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(
    title: String?,
    buttonText: String?
  ) {
    guard let title, let buttonText else {
      isHidden = true
      return
    }
    
    isHidden = false
    label.text = title
    button.setTitle(buttonText, for: .normal)
  }
}
