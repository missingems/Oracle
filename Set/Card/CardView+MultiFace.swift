import DesignComponent
import SwiftUI

extension CardView {
  @ViewBuilder
  func multiFaceContentView(
    leftFace: CardFaceDisplayable?,
    rightFace: CardFaceDisplayable?
  ) -> some View {
    if let leftFace, let rightFace {
      ZStack {
        VStack(alignment: .leading, spacing: 13) {
          multiFaceNameAndCost(
            leftFaceName: leftFace.name,
            leftFaceManaCost: leftFace.tokenisedManaCost,
            rightFaceName: rightFace.name,
            rightFaceManaCost: rightFace.tokenisedManaCost
          )
          
          multiFaceTypeLine(
            leftFaceTypeLine: leftFace.typeLine,
            rightFaceTypeLine: rightFace.typeLine
          )
          
          multiFaceText(
            leftFaceText: leftFace.oracleText,
            rightFaceText: rightFace.oracleText
          )
        }
        
        Rectangle().fill(Color(.separator)).frame(width: 1/Main.nativeScale).padding(.vertical, -13)
      }
      .padding(.top, 13)
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func multiFaceNameAndCost(
    leftFaceName: String?,
    leftFaceManaCost: [String]?,
    rightFaceName: String?,
    rightFaceManaCost: [String]?
  ) -> some View {
    if let leftFaceName, let rightFaceName {
      HStack(alignment: .top, spacing: 0) {
        nameAndManaCostRow(name: leftFaceName, manaCost: leftFaceManaCost)
        nameAndManaCostRow(name: rightFaceName, manaCost: rightFaceManaCost)
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func multiFaceTypeLine(
    leftFaceTypeLine: String?,
    rightFaceTypeLine: String?
  ) -> some View {
    if let leftFaceTypeLine, let rightFaceTypeLine {
      Divider().padding(.leading, 16.0)
      
      HStack(alignment: .top, spacing: 0) {
        typelineRow(typeline: leftFaceTypeLine, shouldRenderDivider: false)
        typelineRow(typeline: rightFaceTypeLine, shouldRenderDivider: false)
      }
    } else {
      EmptyView()
    }
  }
  
  @ViewBuilder
  func multiFaceText(
    leftFaceText: String?,
    rightFaceText: String?
  ) -> some View {
    if let leftFaceText, let rightFaceText {
      Divider().padding(.leading, 16.0)
      
      HStack(alignment: .top, spacing: 0) {
        textRow(text: leftFaceText, shouldRenderDivider: false)
        textRow(text: rightFaceText, shouldRenderDivider: false)
      }
    } else {
      EmptyView()
    }
  }
}
