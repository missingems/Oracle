import ComposableArchitecture
import ScryfallKit
import SwiftUI

@Reducer
struct QueryFeature {
  let client = ScryfallClient()
  
  enum Layout: Equatable {
    case list
    case grid
  }
  
  @ObservableState
  struct State {
    let selectedSet: MTGSet
    var displayingCards: [Card] = []
    var cards: ObjectList<Card>?
    var currentPage = 1
    var viewState = Layout.grid
    var isLoadingMore = false
    
    var title: String {
      selectedSet.name
    }
    
    var subtitle: String {
      String(localized: "\(selectedSet.cardCount) Cards")
    }
    
    var isInteractivable: Bool {
      cards == nil
    }
    
    var redactionReason: RedactionReasons {
      guard cards != nil else {
        return .placeholder
      }
      
      return .invalidated
    }
    
    func shouldShowTransformButton(at index: Int) -> Bool {
      displayingCards[index].isFlippable
    }
    
    func images(at index: Int) -> [URL?] {
      guard let card = cards?.data[index] else {
        return []
      }
      
      if card.isFlippable {
        return card.cardFaces?.compactMap { $0.imageURL } ?? []
      } else {
        return [card.getImageURL(type: .normal)]
      }
    }
    
    func pathState(at index: Int) -> Feature.Path.State {
      Feature.Path.State.showCard(
        CardFeature.State(
          card: (cards?.data[index])!,
          cardSetImageURL: URL(string: selectedSet.iconSvgUri)
        )
      )
    }
  }
  
  enum Action {
    case didReceivedCards(ObjectList<Card>)
    case fetchCards(filter: [CardFieldFilter], page: Int)
    case loadMoreIfNeeded(Int)
    case viewAppeared
    case viewStateChanged(Layout)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .fetchCards(filter, page):
        return .run { update in
          let result = try await client.searchCards(
            filters: filter,
            unique: .prints,
            order: nil,
            sortDirection: nil,
            includeExtras: true,
            includeMultilingual: false,
            includeVariations: true,
            page: page
          )
          
          await update(.didReceivedCards(result))
        }
        
      case .viewAppeared:
        let code = state.selectedSet.code
        let currentPage = state.currentPage
        
        guard state.cards == nil else {
          return .none
        }
        
        return .run { update in
          await update(
            .fetchCards(
              filter: [
                .set(code),
                .game(.paper)
              ],
              page: currentPage
            )
          )
        }
        
      case let .viewStateChanged(viewState):
        state.viewState = viewState
        return .none
        
      case let .loadMoreIfNeeded(index):
        if let cards = state.cards,
           cards.hasMore == true,
           cards.data.count - 3 == index,
           state.isLoadingMore == false {
          state.currentPage += 1
          let code = state.selectedSet.code
          let currentPage = state.currentPage
          state.isLoadingMore = true
          
          return .run { update in
            await update(
              .fetchCards(
                filter: [
                  .set(code),
                  .game(.paper)
                ],
                page: currentPage
              )
            )
          }
        } else {
          return .none
        }
        
      case let .didReceivedCards(cards):
        state.isLoadingMore = false
        
        if let oldCards = state.cards {
          var newCards = cards
          newCards.data.insert(contentsOf: oldCards.data, at: 0)
          state.cards = newCards
        } else {
          state.cards = cards
        }
        
        state.displayingCards = state.cards?.data ?? []
        
        return .none
      }
    }
  }
}
