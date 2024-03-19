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
  
  private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
  private lazy var ambient = Ambient(host: self, configuration: Ambient.Configuration())
  private let viewModel: SetDetailCollectionViewModel
  
  init(_ viewModel: SetDetailCollectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    
    viewModel.didUpdate = { [weak self] message in
      guard let self else { return }
      
      DispatchQueue.main.async {
        switch message {
        case .shouldShowIsLoading:
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
          
        case .shouldReloadData:
          self.ambient.reloadData()
          self.ambient.collectionView.refreshControl?.endRefreshing()
          
          let orderMenuItems = self.viewModel.configuration.availableSortDirection.map { direction in
            let action = UIAction(title: direction.description) { _ in
              self.viewModel.update(.didSelectSortDirection(direction))
            }
            
            action.state = direction == self.viewModel.sortDirection ? .on : .off
            return action
          }
          
          let menuItems = self.viewModel.configuration.availableSort.map { sortMode in
            let action = UIAction(title: sortMode.description) { _ in
              self.viewModel.update(.didSelectSortMode(sortMode))
            }
            
            action.state = sortMode == self.viewModel.sortMode ? .on : .off
            return action
          }
          
          let sortMenu = UIMenu(title: viewModel.selectedSortModeTitle, image: nil, identifier: nil, options: [.singleSelection], children: menuItems)
          let directionMenu = UIMenu(title: viewModel.selectedSortDirectionTitle, image: nil, identifier: nil, options: [.singleSelection], children: orderMenuItems)
          let menu = UIMenu(title: "", image: nil, identifier: nil, options: [.displayInline], children: [sortMenu, directionMenu])
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.viewModel.sortMode.description, image: nil, primaryAction: nil, menu: menu)
        }
      }
    }
    
    ambient.embed(in: view, cells: SetDetailCollectionViewCell.self)
    setContentScrollView(ambient.collectionView)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    activityIndicatorView.startAnimating()
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    view.backgroundColor = .systemBackground
    title = viewModel.configuration.title
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    ambient.collectionView.refreshControl = refreshControl
    
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
  
  @objc
  private func pullToRefresh() {
    viewModel.update(.pullToRefresh)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetDetailCollectionViewCell", for: indexPath) as? SetDetailCollectionViewCell else {
      fatalError()
    }
    
    let card = viewModel.dataSource[indexPath.item]
    
    cell.configure(
      imageURL: card.getImageURL(type: .normal),
      size: .regular,
      price: card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00",
      card: card
    )
    
    cell.imageView.didTappedTransform = { shouldFlipFromRight in
      let url = card.getImageURL(type: .normal, getSecondFace: shouldFlipFromRight)
      
      cell.configure(
        imageURL: url,
        size: .regular,
        price: card.getPrice(for: .usd) ?? card.getPrice(for: .usdFoil) ?? "0.00",
        card: card
      )
    }
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
    let card = viewModel.dataSource[indexPath.item]
    viewModel.update(.didSelectCard(card))
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    viewModel.update(.willDisplayItem(index: indexPath.item))
  }
}
