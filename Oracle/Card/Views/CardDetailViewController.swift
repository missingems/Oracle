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
  private lazy var imageContainerRowView = CardDetailImageContainerRowView(
    imageURL: viewModel.cardImageURL,
    card: viewModel.card
  ) { [weak self] action in
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
  
  private lazy var titleDetailRow = CardTitleDetailRowView(viewModel.name, manaCost: viewModel.manaCost)
  private lazy var typelineRow = CardDetailRowView(viewModel.typeLine)
  private lazy var textRow = CardDetailRowView(viewModel.text)
  private lazy var flavorRow: CardDetailRowView = {
    let fontDescriptor = UIFont
      .preferredFont(forTextStyle: .body)
      .fontDescriptor.withDesign(.serif)?
      .withSymbolicTraits(.traitItalic)
    
    let font = UIFont(descriptor: fontDescriptor!, size: 0)
    let rowView = CardDetailRowView(viewModel.flavorText, font: font, color: .secondaryLabel)
    return rowView
  }()
  private lazy var powerToughnessRow = CardDetailRowView(viewModel.powerToughness)
  private lazy var loyaltyRow = CardDetailRowView(viewModel.loyalty)
  private lazy var illustratorRow = CardIllustratorRowView(
    title: viewModel.illstrautedLabel,
    buttonText: viewModel.artist
  ) {
    print("tapped")
  }
  
  private lazy var viewRulingsButtonRow = ButtonRow(title: viewModel.viewRulingsLabel) { [weak self] in
    self?.viewModel.update(.didSelectRulings)
  }
  
  private lazy var informationRow = CardSetInformationRowView(viewModel.card)
  private lazy var versionRow = CardRelevanceView(cards: viewModel.versions)
  private var viewModel: CardDetailViewModel
  
  init(viewModel: CardDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    viewModel.stateHandler = { [weak self] message in
      switch message {
      case .shouldReconfigureCardDetailPage:
        self?.configure()
        
      case .shouldWiggleView:
        self?.view.animateWiggle()
      }
    }
    
    view.backgroundColor = .tertiarySystemGroupedBackground
    view.preservesSuperviewLayoutMargins = true
    
    let arrangedViews: [UIView]
    
    if viewModel.card.layout == .split {
      let leftStackView = UIStackView(arrangedSubviews: [
        CardTitleDetailRowView(
          viewModel.card.cardFaces?.first?.name,
          manaCost: viewModel.card.cardFaces?.first?.manaCost.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body))
        ),
        CardDetailRowView(viewModel.card.cardFaces?.first?.typeLine),
        CardDetailRowView(viewModel.card.cardFaces?.first?.oracleText, shouldShowSeparator: false),
        UIView(),
      ])
      leftStackView.axis = .vertical
      leftStackView.preservesSuperviewLayoutMargins = true
      
      let leftContentView = UIView()
      leftContentView.addSubview(leftStackView)
      leftStackView.edgeAnchors == leftContentView.edgeAnchors
      let divider = UIView.divider()
      leftContentView.addSubview(divider)
      divider.trailingAnchor == leftContentView.trailingAnchor
      divider.verticalAnchors == leftContentView.verticalAnchors
      leftContentView.preservesSuperviewLayoutMargins = true
      
      let rightStackView = UIStackView(arrangedSubviews: [
        CardTitleDetailRowView(
          viewModel.card.cardFaces?.last?.name,
          manaCost: viewModel.card.cardFaces?.last?.manaCost.attributedText(for: .magicTheGathering, font: .preferredFont(forTextStyle: .body)),
          shouldShowSeparatorFullWidth: true
        ),
        CardDetailRowView(viewModel.card.cardFaces?.last?.typeLine, shouldShowSeparatorFullWidth: true),
        CardDetailRowView(viewModel.card.cardFaces?.last?.oracleText, shouldShowSeparator: false),
        UIView(),
      ])
      rightStackView.axis = .vertical
      rightStackView.preservesSuperviewLayoutMargins = true
      
      let stackView = UIStackView(arrangedSubviews: [
        leftContentView,
        rightStackView,
      ])
      stackView.spacing = 0
      stackView.distribution = .fillEqually
      stackView.preservesSuperviewLayoutMargins = true
      
      arrangedViews = [
        imageContainerRowView,
        stackView,
        .separator(),
        illustratorRow,
        informationRow,
        CardDetailLegalityRowView(legalities: viewModel.card.legalities),
        PriceButtonsRowView(card: viewModel.card),
        viewRulingsButtonRow,
        versionRow
      ]
    } else {
      arrangedViews = [
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
        PriceButtonsRowView(card: viewModel.card),
        viewRulingsButtonRow,
        versionRow
      ]
    }
    
    versionRow.didSelectCard = { [weak self] in
      self?.viewModel.update(.didSelectCard($0))
    }
    
    let stackView = UIStackView(arrangedSubviews: arrangedViews)
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
    
    navigationItem.backButtonTitle = viewModel.backButtonItem
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.update(.viewDidLoad)
  }
  
  private func configure() {
    imageContainerRowView.configure(with: viewModel.cardImageURL, card: viewModel.card)
    titleDetailRow.configure(viewModel.name, manaCost: viewModel.manaCost)
    typelineRow.configure(with: viewModel.typeLine)
    textRow.configure(with: viewModel.text)
    flavorRow.configure(with: viewModel.flavorText)
    loyaltyRow.configure(with: viewModel.loyalty)
    powerToughnessRow.configure(with: viewModel.powerToughness)
    illustratorRow.configure(title: viewModel.illstrautedLabel, buttonText: viewModel.artist)
    versionRow.configure(viewModel.versions)
  }
}
