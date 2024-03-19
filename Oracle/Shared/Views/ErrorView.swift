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
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .preferredFont(forTextStyle: .title1)
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = subtitle
    subtitleLabel.isHidden = subtitle == nil
    subtitleLabel.font = .preferredFont(forTextStyle: .body)
    
    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.preservesSuperviewLayoutMargins = true
    
    addSubview(stackView)
    stackView.edgeAnchors == layoutMarginsGuide.edgeAnchors
    
    preservesSuperviewLayoutMargins = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}
