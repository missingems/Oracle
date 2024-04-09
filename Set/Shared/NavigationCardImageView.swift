import DesignComponent
import SwiftUI

struct NavigationCardImageView<Content: View>: View {
  private let images: [URL?]
  private let linkState: Feature.Path.State
  private let shouldShowTransformButton: Bool
  private let width: CGFloat
  private let content: Content
  
  @State
  private var cycle: Cycle
  
  init(
    images: [URL?],
    linkState: Feature.Path.State,
    shouldShowTransformButton: Bool,
    width: CGFloat,
    cycle: Cycle,
    @ViewBuilder content: () -> Content
  ) {
    self.images = images
    self.linkState = linkState
    self.shouldShowTransformButton = shouldShowTransformButton
    self.width = width
    self.cycle = cycle
    self.content = content()
  }
  
  var body: some View {
    ZStack {
      NavigationLink(state: linkState) {
        VStack(spacing: 5.0) {
          AmbientWebImage(url: images, cycle: cycle)
            .frame(width: width, height: (width * 1.3928).rounded())
          content
        }
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
        .offset(x: width / 2 - 27, y: -44)
        .defersSystemGestures(on: .vertical)
      }
    }
  }
}
