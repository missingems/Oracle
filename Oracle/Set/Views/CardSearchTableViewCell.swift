//
//  CardSearchTableViewCell.swift
//  Oracle
//
//  Created by Jun on 15/3/24.
//

import Anchorage
import UIKit

final class CardSearchTableViewCell: SinkableTableViewCell {
  private let cardNameLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let image = UIImage(systemName: "magnifyingglass")
    let imageView = UIImageView(image: image)
    let imageContainerView = UIView()
    imageContainerView.addSubview(imageView)
    imageView.horizontalAnchors == imageContainerView.horizontalAnchors
    imageView.centerAnchors == imageContainerView.centerAnchors
    let stackView = UIStackView(arrangedSubviews: [
      imageContainerView,
      cardNameLabel,
      UIView()
    ])
    stackView.spacing = 8
    cardNameLabel.font = .preferredFont(forTextStyle: .body)
    cardNameLabel.numberOfLines = 0
    contentView.addSubview(stackView)
    stackView.edgeAnchors == contentView.layoutMarginsGuide.edgeAnchors + UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
    
    let separatorView = UIView.separator()
    contentView.addSubview(separatorView)
    separatorView.horizontalAnchors == contentView.horizontalAnchors
    separatorView.bottomAnchor == contentView.bottomAnchor
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(name: String, query: String?) {
    cardNameLabel.text = name
    
    if let query, !query.isEmpty {
      let attributedString = NSMutableAttributedString(string: name)
      
      if let range = name.lowercased().range(of: query.lowercased()) {
        let nsRange = NSRange(range, in: name)
        attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: nsRange)
      }
      
      cardNameLabel.textColor = .secondaryLabel
      cardNameLabel.attributedText = attributedString
    } else {
      cardNameLabel.textColor = .label
      cardNameLabel.text = name
    }
  }
}