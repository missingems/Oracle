//
//  PriceButtonsView.swift
//  Oracle
//
//  Created by Jun on 19/3/24.
//

import Anchorage
import UIKit

final class PriceButtonsRowView: UIView {
  private let button: UIButton
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  init(title: String?, didTapped: @escaping () -> ()) {
    var configuration = UIButton.Configuration.tinted()
    configuration.image = UIImage(systemName: "book.closed.fill")
    configuration.imagePadding = 5.0
    configuration.cornerStyle = .large
    configuration.attributedTitle = AttributedString(title ?? "", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body)]))
    
    button = UIButton(
      configuration: configuration,
      primaryAction: UIAction(
        handler: { _ in
          didTapped()
        }
      )
    )
    
    super.init(frame: .zero)
    addSubview(button)
    button.edgeAnchors == layoutMarginsGuide.edgeAnchors
    button.heightAnchor >= 44.0
    preservesSuperviewLayoutMargins = true
  }
}
