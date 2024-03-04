import Anchorage
import UIKit

final class CardDetailRowView: UIView {
  private(set) lazy var label = UILabel()
  
  init(
    _ attributedString: NSAttributedString?,
    font: UIFont = .preferredFont(forTextStyle: .body),
    color: UIColor = .label
  ) {
    super.init(frame: .zero)
    
    label.attributedText = attributedString
    commonInit(with: font, color: color)
  }
  
  init(
    _ string: String?,
    font: UIFont = .preferredFont(forTextStyle: .body),
    color: UIColor = .label
  ) {
    super.init(frame: .zero)
    
    label.text = string
    commonInit(with: font, color: color)
  }
  
  private func commonInit(with font: UIFont, color: UIColor) {
    label.font = font
    label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = color
    
    preservesSuperviewLayoutMargins = true
    addSubview(label)
    
    label.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    label.verticalAnchors == verticalAnchors + 11
    
    let seperator = UIView.separator()
    addSubview(seperator)
    seperator.bottomAnchor == bottomAnchor
    seperator.horizontalAnchors == horizontalAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with string: String?) {
    guard let string else {
      isHidden = true
      return
    }
    
    isHidden = false
    label.text = string
  }
  
  func configure(with attributedText: NSAttributedString?) {
    guard let attributedText else {
      isHidden = true
      return
    }
    
    isHidden = false
    label.attributedText = attributedText
  }
}
