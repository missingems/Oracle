import Anchorage
import UIKit
import ScryfallKit

final class SetDetailCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
  private lazy var titleLabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .headline)
    label.textAlignment = .center
    return label
  }()
  
  private lazy var subtitleLabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textAlignment = .center
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var ambient = Ambient(host: self, configuration: Ambient.Configuration())
  private let viewModel: SetDetailCollectionViewModel
  
  init(_ viewModel: SetDetailCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    ambient.embed(in: view, cells: SetDetailCollectionViewCell.self)
    setContentScrollView(ambient.collectionView)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground
    title = viewModel.title
    
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      subtitleLabel
    ])
    stackView.axis = .vertical
    
    navigationItem.titleView = stackView
    
    Task { [weak self] in
      guard let self else {
        return
      }
      
      switch await self.viewModel.fetchCards() {
      case .loading:
        break
        
      case .data:
        ambient.reloadData()
        
      case .error:
        break
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetDetailCollectionViewCell", for: indexPath) as? SetDetailCollectionViewCell else {
      fatalError()
    }
    
    cell.configure(viewModel.state.cards[indexPath.row])
    
    if collectionView === ambient.collectionView {
      cell.onHighlighted = { [weak self] isHighlighted in
        self?.ambient.syncHighlightedCell(at: indexPath, isHighlighted: isHighlighted)
      }
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.state.cards.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 11
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.size.width - 24) / 2
    return CGSize(width: width, height: width * (936 / 672))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 5, left: 8, bottom: 20, right: 8)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ambient.syncScroll(ambient.collectionView)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let card = viewModel.state.cards[indexPath.item]
    let cardViewController = CardDetailViewController(viewModel: CardDetailViewModel(card: card, set: viewModel.set))
    self.navigationController?.pushViewController(cardViewController, animated: true)
  }
}
