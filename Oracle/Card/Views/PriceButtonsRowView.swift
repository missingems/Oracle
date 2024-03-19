//
//  PriceButtonsView.swift
//  Oracle
//
//  Created by Jun on 19/3/24.
//

import Anchorage
import ScryfallKit
import UIKit

final class PriceButtonsRowView: UIView {
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  init(card: Card) {
    super.init(frame: .zero)
    
    let usdButton = UIButton(configuration: .tinted())
    let usdFoilButton = UIButton(configuration: .tinted())
    let eurButton = UIButton(configuration: .tinted())
    
    usdButton.configuration?.attributedTitle = AttributedString(
      "$\(card.getPrice(for: .usd) ?? "0.00")",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)])
    )
    usdButton.configuration?.attributedSubtitle = AttributedString(
      "USD",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2)])
    )
    usdButton.configuration?.titleAlignment = .center
    usdButton.configuration?.cornerStyle = .large
    
    usdFoilButton.configuration?.attributedTitle = AttributedString(
      "$\(card.getPrice(for: .usdFoil) ?? "0.00")",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)])
    )
    usdFoilButton.configuration?.attributedSubtitle = AttributedString(
      "USD - Foil",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2)])
    )
    usdFoilButton.configuration?.titleAlignment = .center
    usdFoilButton.configuration?.cornerStyle = .large
    
    eurButton.configuration?.attributedTitle = AttributedString(
      "€\(card.getPrice(for: .eur) ?? "0.00")",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .regular)])
    )
    eurButton.configuration?.attributedSubtitle = AttributedString(
      "EUR",
      attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2)])
    )
    eurButton.configuration?.titleAlignment = .center
    eurButton.configuration?.cornerStyle = .large
    
    let stackView = UIStackView(arrangedSubviews: [
      usdButton,
      usdFoilButton,
      eurButton,
    ])
    
    let titleLabel = UILabel()
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.text = String(localized: "Prices")
    addSubview(titleLabel)
    titleLabel.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    titleLabel.topAnchor == topAnchor + 13
    
    addSubview(stackView)
    stackView.spacing = 8.0
    stackView.distribution = .fillEqually
    stackView.heightAnchor >= 49
    stackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    stackView.bottomAnchor == bottomAnchor - 8
    stackView.topAnchor == titleLabel.bottomAnchor + 13
    preservesSuperviewLayoutMargins = true
    stackView.preservesSuperviewLayoutMargins = true
  }
}
