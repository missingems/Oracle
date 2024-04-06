import DesignComponent
import SwiftUI

struct NavigationCardImageView: View {
  private let images: [URL?]
  private let linkState: Feature.Path.State
  private let shouldShowTransformButton: Bool
  private let width: CGFloat
  
  @State
  private var cycle: Cycle
  
  init(
    images: [URL?],
    linkState: Feature.Path.State,
    shouldShowTransformButton: Bool,
    width: CGFloat,
    cycle: Cycle
  ) {
    self.images = images
    self.linkState = linkState
    self.shouldShowTransformButton = shouldShowTransformButton
    self.width = width
    self.cycle = cycle
  }
  
  var body: some View {
    ZStack {
      NavigationLink(state: linkState) {
        AmbientWebImage(url: images, cycle: cycle)
      }
      
      if shouldShowTransformButton {
        Button {
          cycle.next()
        } label: {
          Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
        }
        .frame(
          width: 44.0,
          height: 44.0,
          alignment: .center
        )
        .background(.thinMaterial)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(.separator), lineWidth: 1 / Main.nativeScale).opacity(0.618))
        .offset(x: width / 2 - 27, y: -5)
        .defersSystemGestures(on: .vertical)
      }
    }
    .frame(width: width, height: (width * 1.3928).rounded())
  }
}
