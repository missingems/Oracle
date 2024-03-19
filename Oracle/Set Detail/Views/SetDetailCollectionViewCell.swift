import Anchorage
import UIKit
import ScryfallKit

final class SetDetailCollectionViewCell: SinkableCollectionViewCell {
  let imageView = CardView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    contentView.addSubview(imageView)
    imageView.edgeAnchors == contentView.edgeAnchors
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func configure(imageURL: URL?, size: CardView.Size = .regular, price: String?, card: Card) {
    imageView.configure(imageURL: imageURL, imageType: .normal, size: size, price: price, card: card)
  }
}
