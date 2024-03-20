//
//  LoadingView.swift
//  Oracle
//
//  Created by Jun on 19/3/24.
//

import Anchorage
import UIKit

final class ErrorView: UIView {
  init(title: String, subtitle: String?) {
    super.init(frame: .zero)
    let imageView = UIImageView(image: UIImage(systemName: "wifi.slash")?.withRenderingMode(.alwaysTemplate))
    imageView.sizeAnchors == CGSize(width: 55, height: 55)
    imageView.tintColor = .accent
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.textAlignment = .center
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = subtitle
    subtitleLabel.isHidden = subtitle == nil
    subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.textAlignment = .center
    subtitleLabel.numberOfLines = 0
    
    let retryButton = UIButton(configuration: .tinted())
    retryButton.setTitle("Retry", for: .normal)
    
    let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel, retryButton, UIView()])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 3
    stackView.setCustomSpacing(13, after: subtitleLabel)
    stackView.preservesSuperviewLayoutMargins = true
    
    addSubview(stackView)
    stackView.centerAnchors == centerAnchors
    stackView.horizontalAnchors == layoutMarginsGuide.horizontalAnchors - 13.0
    
    preservesSuperviewLayoutMargins = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
