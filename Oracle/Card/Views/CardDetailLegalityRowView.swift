import Anchorage
import UIKit
import ScryfallKit

final class CardDetailLegalityRowView: UIView {
  init(legalities: Card.Legalities) {
    super.init(frame: .zero)
    let view = legalitiesView(legalities)
    addSubview(view)
    preservesSuperviewLayoutMargins = true
    
    view.edgeAnchors == edgeAnchors
    
    let separator = UIView.separator(fullWidth: true)
    addSubview(separator)
    separator.bottomAnchor == bottomAnchor
    separator.horizontalAnchors == horizontalAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func legalitiesView(_ legalities: Card.Legalities) -> UIView {
    func row(_ value: (String, Card.Legality?)..., shouldRenderBackground: Bool, isFirst: Bool, isLast: Bool) -> UIView {
      let left = value.first
      let label = UILabel()
      label.font = .systemFont(ofSize: 12, weight: .regular)
      label.text = left?.0
      label.textAlignment = .center
      let description = InsetLabel(UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3))
      description.layer.cornerRadius = 3
      description.layer.cornerCurve = .continuous
      description.font = .monospacedSystemFont(ofSize: 12, weight: .medium)
      description.text = left?.1?.localisedDescription
      description.textColor = UIColor(white: 1, alpha: 1)
      description.textAlignment = .center
      description.clipsToBounds = true
      description.backgroundColor = left?.1?.color ?? .clear
      description.widthAnchor >= 90
      let stackView1 = UIStackView(arrangedSubviews: [
        description, label, UIView()
      ])
      stackView1.spacing = 5
      
      let right = value.last
      let label2 = UILabel()
      label2.font = .systemFont(ofSize: 12, weight: .regular)
      label2.text = right?.0
      label2.textAlignment = .center
      let description2 = InsetLabel(UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3))
      description2.layer.cornerRadius = 3
      description2.layer.cornerCurve = .continuous
      description2.clipsToBounds = true
      description2.font = .monospacedSystemFont(ofSize: 12, weight: .medium)
      description2.text = right?.1?.localisedDescription
      description2.textColor = UIColor(white: 1, alpha: 1)
      description2.textAlignment = .center
      description2.backgroundColor = right?.1?.color ?? .clear
      description2.widthAnchor >= 90
      let stackView2 = UIStackView(arrangedSubviews: [
        description2, label2, UIView()
      ])
      stackView2.spacing = 5
      
      let stackView = UIStackView(arrangedSubviews: [
        stackView1,
        UIView(),
        stackView2
      ])
      stackView1.widthAnchor == stackView.widthAnchor / 2
      stackView2.widthAnchor == stackView.widthAnchor / 2
      stackView.axis = .horizontal
      let view = UIView()
      view.addSubview(stackView)
      stackView.edgeAnchors == view.edgeAnchors
      
      if shouldRenderBackground {
        view.backgroundColor = .quaternarySystemFill
        view.layer.cornerRadius = 3
        view.layer.cornerCurve = .continuous
      }
      return view
    }
    
    let titleLabel = UILabel()
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.text = String(localized: "Legality")
    
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      row(legalities.type(.standard), legalities.type(.pioneer), shouldRenderBackground: true, isFirst: true, isLast: false),
      row(legalities.type(.modern), legalities.type(.historic), shouldRenderBackground: false, isFirst: false, isLast: false),
      row(legalities.type(.legacy), legalities.type(.brawl), shouldRenderBackground: true, isFirst: false, isLast: false),
      row(legalities.type(.vintage), legalities.type(.pauper), shouldRenderBackground: false, isFirst: false, isLast: false),
      row(legalities.type(.commander), legalities.type(.penny), shouldRenderBackground: true, isFirst: false, isLast: true),
    ])
    stackView.spacing = 3.0
    stackView.setCustomSpacing(13, after: titleLabel)
    
    stackView.axis = .vertical
    let view = UIView()
    view.addSubview(stackView)
    stackView.horizontalAnchors == view.layoutMarginsGuide.horizontalAnchors
    stackView.verticalAnchors == view.verticalAnchors + 13
    view.preservesSuperviewLayoutMargins = true
    return view
  }
}
