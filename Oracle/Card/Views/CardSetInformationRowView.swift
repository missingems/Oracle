//
//  CardSetInformationRowView.swift
//  Oracle
//
//  Created by Jun on 5/3/24.
//

import ScryfallKit
import Anchorage
import UIKit

final class CardSetInformationRowView: UIView {
  private let rarityLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .caption1))
  private let cardNumberLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .caption1))
  private let setNameLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .caption1), textColor: .secondaryLabel)
  private let iconImageView = UIImageView()
  
  private lazy var setIdLabel = {
    let label = InsetLabel()
    let caption = UIFont.preferredFont(forTextStyle: .caption1)
    label.font = .monospacedSystemFont(ofSize: caption.pointSize, weight: .regular)
    label.numberOfLines = 0
    label.backgroundColor = .systemFill
    label.textColor = .label
    label.setContentHuggingPriority(.required, for: .vertical)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.layer.cornerRadius = 3
    label.layer.cornerCurve = .continuous
    label.textAlignment = .center
    label.clipsToBounds = true
    return label
  }()
  
  init(_ card: Card, setSymbolURI: String?) {
    super.init(frame: .zero)
    
    let rarityAndCardNumberStackView = UIStackView(arrangedSubviews: [
      rarityLabel, cardNumberLabel, UIView()
    ])
    rarityAndCardNumberStackView.spacing = 5
    
    let setStackView = UIStackView(arrangedSubviews: [
      setIdLabel, setNameLabel, UIView()
    ])
    setStackView.spacing = 5
    
    let verticalStackView = UIStackView(arrangedSubviews: [
      rarityAndCardNumberStackView,
      setStackView,
    ])
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 3
    
    let horizontalStackView = UIStackView(arrangedSubviews: [
      verticalStackView,
      UIView(),
      iconImageView.wrapped(size: CGSize(width: 30, height: 30)),
    ])
    horizontalStackView.preservesSuperviewLayoutMargins = true
    
    addSubview(horizontalStackView)
    horizontalStackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    horizontalStackView.verticalAnchors == verticalAnchors + 13.0
    
    let separatorView = UIView.separator()
    addSubview(separatorView)
    separatorView.bottomAnchor == bottomAnchor
    separatorView.horizontalAnchors == horizontalAnchors
    
    preservesSuperviewLayoutMargins = true
    configure(card, setSymbolURI: setSymbolURI)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ card: Card, setSymbolURI: String?) {
    rarityLabel.text = card.rarity.rawValue.capitalized
    cardNumberLabel.text = "#\(card.collectorNumber)"
    setIdLabel.text = card.set.uppercased()
    setNameLabel.text = card.setName
    
    if let setSymbolURI {
      iconImageView.setSVGImage(URL(string: setSymbolURI))
    } else {
      iconImageView.image = nil
    }
  }
  
  private static func makeLabel(font: UIFont, textColor: UIColor = .label) -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textColor
    return label
  }
}
