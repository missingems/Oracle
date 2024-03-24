//import UIKit
//
//extension String {
//  enum Game {
//    case magicTheGathering
//    
//    func attributedString(text: String, font: UIFont) -> NSAttributedString {
//      switch self {
//      case .magicTheGathering:
//        // Create a mutable attributed string
//        let attributedString = NSMutableAttributedString(string: text)
//        
//        // Regular expression to find all patterns of the form {Anything}
//        let regexPattern = "\\{[^}]+\\}"
//        
//        // Try to create a regular expression object
//        if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
//          // Find matches in the entire range of the string
//          let matches = regex.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length))
//          
//          // Iterate over matches in reverse order
//          for match in matches.reversed() {
//            let matchRange = match.range
//            let matchedString = (attributedString.string as NSString).substring(with: matchRange)
//            
//            // Create the NSTextAttachment
//            let textAttachment = NSTextAttachment()
//            textAttachment.image = UIImage(
//              named: matchedString
//                .replacingOccurrences(of: "/", with: ":")
//                .replacingOccurrences(of: "∞", with: "INFINITY")
//            ) // Use the matched string including the braces
//            
//            // Get the label's font size and adjust the image size
//            let fontSize = font.pointSize
//            if let image = textAttachment.image {
//              let aspectRatio = image.size.width / image.size.height
//              let adjustedHeight = fontSize
//              let adjustedWidth = adjustedHeight * aspectRatio
//              
//              textAttachment.bounds = CGRect(x: 0, y: (font.descender) + 2, width: adjustedWidth, height: adjustedHeight)
//            }
//            
//            // Replace the placeholder text with the image
//            attributedString.replaceCharacters(in: matchRange, with: NSAttributedString(attachment: textAttachment))
//          }
//        }
//        
//        // Define paragraph styling
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.paragraphSpacing = 8
//        
//        // Apply paragraph style to the entire string
//        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
//        
//        return attributedString
//      }
//    }
//  }
//  
//  func attributedText(for type: Game, font: UIFont) -> NSAttributedString {
//    return type.attributedString(text: self, font: font)
//  }
//}
