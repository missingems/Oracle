import Anchorage
import UIKit

final class CardDetailRowView: UIView {
  private(set) lazy var label = UILabel()
  
  init(
    _ attributedString: NSAttributedString?,
    font: UIFont = .preferredFont(forTextStyle: .body),
    color: UIColor = .label,
    shouldShowSeparator: Bool = true,
    shouldShowSeparatorFullWidth: Bool = false
  ) {
    super.init(frame: .zero)
    
    commonInit(with: font, color: color, shouldShowSeparator: shouldShowSeparator, shouldShowSeparatorFullWidth: shouldShowSeparatorFullWidth)
    configure(with: attributedString)
  }
  
  init(
    _ string: String?,
    font: UIFont = .preferredFont(forTextStyle: .body),
    color: UIColor = .label,
    shouldShowSeparator: Bool = true,
    shouldShowSeparatorFullWidth: Bool = false
  ) {
    super.init(frame: .zero)
    
    commonInit(with: font, color: color, shouldShowSeparator: shouldShowSeparator, shouldShowSeparatorFullWidth: shouldShowSeparatorFullWidth)
    configure(with: string)
  }
  
  private func commonInit(with font: UIFont, color: UIColor, shouldShowSeparator: Bool, shouldShowSeparatorFullWidth: Bool) {
    label.font = font
    label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = color
    
    preservesSuperviewLayoutMargins = true
    addSubview(label)
    
    label.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    label.verticalAnchors == verticalAnchors + 11
    
    if shouldShowSeparator {
      let separator: UIView
      
      if shouldShowSeparatorFullWidth {
        separator = UIView.separator(fullWidth: true)
      } else {
        separator = UIView.separator()
      }
      
      addSubview(separator)
      separator.bottomAnchor == bottomAnchor
      separator.horizontalAnchors == horizontalAnchors
    }
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
