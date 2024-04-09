import DesignComponent
import SwiftUI

struct NavigationCardImageView<Content: View>: View {
  private let imageURLs: [URL?]
  private let linkState: Feature.Path.State
  private let shouldShowTransformButton: Bool
  private let width: CGFloat
  private let content: Content
  
  @State
  private var cycle: Cycle
  
  init(
    imageURLs: [URL?],
    linkState: Feature.Path.State,
    shouldShowTransformButton: Bool,
    width: CGFloat,
    @ViewBuilder content: () -> Content
  ) {
    self.imageURLs = imageURLs
    self.linkState = linkState
    self.shouldShowTransformButton = shouldShowTransformButton
    self.width = width
    self.cycle = Cycle(max: imageURLs.count)
    self.content = content()
  }
  
  var body: some View {
    ZStack {
      NavigationLink(state: linkState) {
        VStack(spacing: 5.0) {
          AmbientWebImage(url: imageURLs, cycle: cycle, width: width).frame(width: width, height: (width * 1.3928).rounded())
          content
        }
      }
      
      if shouldShowTransformButton {
        Button {
          cycle.next()
        } label: {
          Image(systemName: "rectangle.portrait.rotate").fontWeight(.semibold)
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
      }
    }
  }
}
