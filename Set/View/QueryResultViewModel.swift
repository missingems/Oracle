import ComposableArchitecture
import ScryfallKit
import SwiftUI

struct QueryResultViewModel {
  let selectedSet: MTGSet
  
  @Bindable
  var store: StoreOf<Feature>
}
