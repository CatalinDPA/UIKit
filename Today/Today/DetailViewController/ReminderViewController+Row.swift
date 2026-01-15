import UIKit

nonisolated enum DetailRow: Hashable, Sendable {
    case header(String)
    case title
    case date
    case notes
    case time
    case editableText(String)

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    var imageName: String? {
        switch self {
        case .date: return "calendar.circle"
        case .notes: return "square.and.pencil"
        case .time: return "clock"
        default: return nil
        }
    }


     var image: UIImage? {
         guard let imageName else { return nil }
         let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
         return UIImage(systemName: imageName, withConfiguration: configuration)
     }

     var textStyle: UIFont.TextStyle {
         switch self {
         case .title: return .headline
         default: return .subheadline
         }
     }
}

