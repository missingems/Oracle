import SwiftUI

struct SetListView: View {
  var viewModel: SetListViewModel
  
  public var body: some View {
    List(viewModel.store.sets) { set in
      Text(set.name)
    }
  }
}
