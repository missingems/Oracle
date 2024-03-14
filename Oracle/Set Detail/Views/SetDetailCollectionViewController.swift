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
    
    viewModel.didUpdate = { [weak self] message in
      DispatchQueue.main.async {
        switch message {
        case .shouldReloadData:
          self?.ambient.reloadData()
        }
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground
    title = viewModel.configuration.title
    
    titleLabel.text = viewModel.configuration.title
    subtitleLabel.text = viewModel.configuration.subtitle
    
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      subtitleLabel
    ])
    stackView.axis = .vertical
    navigationItem.titleView = stackView
    
    viewModel.update(.viewDidLoad)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetDetailCollectionViewCell", for: indexPath) as? SetDetailCollectionViewCell else {
      fatalError()
    }
    cell.configure(viewModel.dataSource[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    13
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    8
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.size.width - 24) / 2
    return CGSize(width: width, height: width * 1.3928 + 26)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView === ambient.collectionView {
      return UIEdgeInsets(top: 13, left: 8, bottom: 20, right: 8)
    } else {
      return UIEdgeInsets(top: 34, left: 8, bottom: 20, right: 8)
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ambient.syncScroll(ambient.collectionView)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    let card = viewModel.state.cards[indexPath.item]
//    let cardViewController = CardDetailViewController(viewModel: CardDetailViewModel(card: card, set: viewModel.set))
//    self.navigationController?.pushViewController(cardViewController, animated: true)
  }
}
