import Anchorage
import UIKit
import ScryfallKit

final class CardRelevanceView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  private lazy var ambient: Ambient = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: 150, height: 150 * 1.3928 + 26)
    flowLayout.minimumInteritemSpacing = 8.0
    flowLayout.minimumLineSpacing = 8.0
    
    return Ambient(
      host: self,
      configuration: Ambient.Configuration(
        titleFont: .preferredFont(forTextStyle: .headline),
        title: String(localized: "Prints"),
        flowLayout: flowLayout
      )
    )
  }()
  
  private var cards: [Card]
  
  init(cards: [Card]) {
    self.cards = cards
    super.init(frame: .zero)
    ambient.embed(in: self, cells: SetDetailCollectionViewCell.self)
    preservesSuperviewLayoutMargins = true
    
    let separatorView = UIView.separator(fullWidth: true)
    addSubview(separatorView)
    separatorView.bottomAnchor == bottomAnchor
    separatorView.horizontalAnchors == horizontalAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetDetailCollectionViewCell", for: indexPath) as? SetDetailCollectionViewCell else {
      fatalError()
    }
    
    let card = cards[indexPath.item]
    
    cell.configure(
      imageURL: card.getImageURL(type: .normal),
      size: .regular,
      price: card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00",
      layout: card.layout
    )
    
    cell.imageView.didTappedTransform = { shouldFlipFromRight in
      let url = card.getImageURL(type: .normal, getSecondFace: shouldFlipFromRight)
      
      cell.configure(
        imageURL: url,
        size: .regular,
        price: card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00",
        layout: card.layout
      )
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView === ambient.collectionView {
      return UIEdgeInsets(top: 0, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
    } else {
      return UIEdgeInsets(top: 13, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    cards.count
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ambient.syncScroll(ambient.collectionView)
  }
  
  func configure(_ cards: [Card]) {
    self.cards = cards
    ambient.reloadData()
  }
}
