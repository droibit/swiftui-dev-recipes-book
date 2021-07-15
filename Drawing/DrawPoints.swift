import SwiftUI

struct DrawPoints: Identifiable {
    let id = UUID()
    var points: [CGPoint]
    var color: Color
}

enum DrawColor {
    case red
    case clear

    func callAsFunction() -> Color {
        switch self {
        case .red:
            return .red
        case .clear:
            return .white
        }
    }
}
