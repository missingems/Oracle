import SwiftUI

struct SetView: View {
  var viewModel: SetViewModel
  
  public var body: some View {
    List(viewModel.store.sets) { set in
      Text(set.name)
    }
  }
}
