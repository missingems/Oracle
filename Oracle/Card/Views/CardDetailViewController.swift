//
//  CardDetailViewController.swift
//  Oracle
//
//  Created by Jun on 27/2/24.
//

import Anchorage
import ScryfallKit
import SDWebImage
import UIKit
import SwiftUI

final class CardDetailViewController: UIViewController {
  private lazy var imageContainerRowView = CardDetailImageContainerRowView(card: viewModel.card) { [weak self] action in
    guard let self else {
      return
    }
    
    switch action {
    case .transformTapped:
      self.viewModel.transformTapped()
      
    default:
      break
    }
  }
  
  private lazy var titleDetailRow = CardTitleDetailRowView()
  private lazy var typelineRow = CardDetailTypelineRowView(title: viewModel.typeLine, iconURI: viewModel.set.iconURI)
  private lazy var textRow = CardDetailRowView(viewModel.text)
  private lazy var powerToughnessRow = CardDetailRowView(viewModel.powerToughness)
  private lazy var loyaltyRow = CardDetailRowView(viewModel.loyalty)
  private lazy var illustratorRow = CardIllustratorRowView(
    title: viewModel.illstrautedLabel,
    buttonText: viewModel.artist
  ) {
    print("tapped")
  }
  
  private lazy var informationRow = CardSetInformationRowView(viewModel.card)
  private lazy var versionRow = CardVersionRowView(cards: viewModel.versions)
  
  private lazy var flavorRow: CardDetailRowView = {
    let fontDescriptor = UIFont
      .preferredFont(forTextStyle: .body)
      .fontDescriptor.withDesign(.serif)?
      .withSymbolicTraits(.traitItalic)
    
    let font = UIFont(descriptor: fontDescriptor!, size: 0)
    let rowView = CardDetailRowView(viewModel.flavorText, font: font, color: .secondaryLabel)
    return rowView
  }()
  
  private var viewModel: CardDetailViewModel {
    didSet {
      configure()
    }
  }
  
  init(viewModel: CardDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = .tertiarySystemGroupedBackground
    view.preservesSuperviewLayoutMargins = true
    
    let arrangedViews: [UIView] = [
      imageContainerRowView,
      titleDetailRow,
      typelineRow,
      textRow,
      flavorRow,
      loyaltyRow,
      powerToughnessRow,
      illustratorRow,
      informationRow,
      CardDetailLegalityRowView(legalities: viewModel.card.legalities),
      versionRow
    ]
    
    let stackView = UIStackView(arrangedSubviews: arrangedViews)
    stackView.setCustomSpacing(5.0, after: imageContainerRowView)
    stackView.preservesSuperviewLayoutMargins = true
    stackView.axis = .vertical
    imageContainerRowView.widthAnchor == stackView.widthAnchor
    
    let scrollView = UIScrollView()
    scrollView.preservesSuperviewLayoutMargins = true
    scrollView.addSubview(stackView)
    stackView.edgeAnchors == scrollView.contentLayoutGuide.edgeAnchors
    stackView.widthAnchor == scrollView.frameLayoutGuide.widthAnchor
    
    view.addSubview(scrollView)
    scrollView.edgeAnchors == view.edgeAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    
    Task { [weak self] in
      await self?.viewModel.fetchAllPrints()
    }
  }
  
  private func configure() {
    imageContainerRowView.configure(with: viewModel.cardImageURL)
    titleDetailRow.configure(viewModel.name, manaCost: viewModel.manaCost)
    typelineRow.configure(title: viewModel.typeLine, iconURI: viewModel.set.iconURI)
    textRow.configure(with: viewModel.text)
    flavorRow.configure(with: viewModel.flavorText)
    loyaltyRow.configure(with: viewModel.loyalty)
    powerToughnessRow.configure(with: viewModel.powerToughness)
    illustratorRow.configure(title: viewModel.illstrautedLabel, buttonText: viewModel.artist)
    versionRow.configure(viewModel.versions)
  }
}
