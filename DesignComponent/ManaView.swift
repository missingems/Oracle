import SwiftUI

public struct ManaView: View {
  let identity: [String]
  let size: CGSize
  let spacing: CGFloat
  
  public init(identity: [String], size: CGSize, spacing: CGFloat = 3) {
    self.identity = identity
    self.size = size
    self.spacing = spacing
  }
  
  public var body: some View {
    HStack(spacing: spacing) {
      ForEach(identity.indices, id: \.self) { index in
        Image(identity[index])
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size.width, height: size.height)
          .background { Circle().fill(Color.black).offset(x: -0.75, y: 1.5) }
      }
    }
  }
}

