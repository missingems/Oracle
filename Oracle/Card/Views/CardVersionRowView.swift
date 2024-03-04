import Anchorage
import UIKit
import ScryfallKit

final class CardVersionRowView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  private lazy var ambient: Ambient = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.itemSize = CGSize(width: 130.0, height: 130.0 * (936.0 / 672.0))
    flowLayout.minimumInteritemSpacing = 8.0
    
    return Ambient(
      host: self,
      configuration: Ambient.Configuration(
        titleFont: .preferredFont(forTextStyle: .headline),
        title: "Versions",
        flowLayout: flowLayout,
        height: 130.0 * (936.0 / 672.0)
      )
    )
  }()
  
  var cards: [Card]
  
  init(cards: [Card]) {
    self.cards = cards
    super.init(frame: .zero)
    ambient.embed(in: self, cells: SetDetailCollectionViewCell.self)
    preservesSuperviewLayoutMargins = true
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetDetailCollectionViewCell", for: indexPath) as? SetDetailCollectionViewCell else {
      fatalError()
    }
    
    cell.configure(cards[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: layoutMargins.left, bottom: 0, right: layoutMargins.right)
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
