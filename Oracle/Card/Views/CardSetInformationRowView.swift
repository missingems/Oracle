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
  private let rarityLabel = CardSetInformationRowView.makeCaptionLabel()
  private let cardNumberLabel = CardSetInformationRowView.makeCaptionLabel()
  private let setNameLabel = CardSetInformationRowView.makeCaptionLabel(textColor: .secondaryLabel)
  
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
      cardNumberLabel, rarityLabel
    ])
    rarityAndCardNumberStackView.spacing = 5
    
    let setStackView = UIStackView(arrangedSubviews: [
      setIdLabel, setNameLabel
    ])
    setStackView.spacing = 5
    
    let contentStackView = UIStackView(arrangedSubviews: [
      setStackView,
      UIView(),
      rarityAndCardNumberStackView,
    ])
    contentStackView.spacing = 5.0
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = .quaternarySystemFill
    backgroundView.addSubview(contentStackView)
    contentStackView.horizontalAnchors == backgroundView.horizontalAnchors + 8
    contentStackView.verticalAnchors == backgroundView.verticalAnchors + 13.0
    backgroundView.layer.cornerCurve = .continuous
    backgroundView.layer.cornerRadius = 9
    backgroundView.clipsToBounds = true
    
    addSubview(backgroundView)
    backgroundView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors
    backgroundView.verticalAnchors == verticalAnchors
    preservesSuperviewLayoutMargins = true
    configure(card)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ card: Card) {
    rarityLabel.text = card.rarity.rawValue.capitalized
    cardNumberLabel.text = "#\(card.collectorNumber)"
    setIdLabel.text = card.set.uppercased()
    setNameLabel.text = card.setName
  }
  
  private static func makeCaptionLabel(textColor: UIColor = .label) -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .caption1)
    label.textColor = textColor
    return label
  }
}
