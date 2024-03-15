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
  private let rarityLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .footnote))
  private let cardNumberLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .footnote))
  private let setNameLabel = CardSetInformationRowView.makeLabel(font: .preferredFont(forTextStyle: .footnote), textColor: .secondaryLabel)
  
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
  
  init(_ card: Card) {
    super.init(frame: .zero)
    
    let rarityAndCardNumberStackView = UIStackView(arrangedSubviews: [
      rarityLabel, cardNumberLabel, UIView()
    ])
    rarityAndCardNumberStackView.spacing = 5
    
    let setStackView = UIStackView(arrangedSubviews: [
      setIdLabel, setNameLabel, UIView()
    ])
    setStackView.spacing = 5
    
    let contentStackView = UIStackView(arrangedSubviews: [
      rarityAndCardNumberStackView,
      setStackView,
    ])
    contentStackView.axis = .vertical
    contentStackView.spacing = 5.0
    
    let backgroundView = UIView()
    backgroundView.addSubview(contentStackView)
    contentStackView.horizontalAnchors == backgroundView.horizontalAnchors
    contentStackView.verticalAnchors == backgroundView.verticalAnchors + 13.0
    
    addSubview(backgroundView)
    backgroundView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    backgroundView.verticalAnchors == verticalAnchors
    preservesSuperviewLayoutMargins = true
    configure(card)
    
    let separator = UIView.separator()
    addSubview(separator)
    separator.horizontalAnchors == horizontalAnchors
    separator.bottomAnchor == bottomAnchor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ card: Card) {
    rarityLabel.text = card.rarity.rawValue.capitalized
    cardNumberLabel.text = "\(card.collectorNumber)"
    setIdLabel.text = card.set.uppercased()
    setNameLabel.text = card.setName
  }
  
  private static func makeLabel(font: UIFont, textColor: UIColor = .label) -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textColor
    return label
  }
}
