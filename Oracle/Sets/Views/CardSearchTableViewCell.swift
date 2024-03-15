//
//  CardSearchTableViewCell.swift
//  Oracle
//
//  Created by Jun on 15/3/24.
//

import Anchorage
import UIKit

final class CardSearchTableViewCell: UITableViewCell {
  private let cardNameLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    cardNameLabel.font = .preferredFont(forTextStyle: .body)
    contentView.addSubview(cardNameLabel)
    cardNameLabel.edgeAnchors == contentView.layoutMarginsGuide.edgeAnchors + UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(name: String, query: String) {
    cardNameLabel.text = name
  }
}
