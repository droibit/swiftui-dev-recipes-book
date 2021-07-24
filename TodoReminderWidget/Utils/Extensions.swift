import SwiftUI

extension TodoPriority {
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .yellow
        case .low:
            return .green
        }
    }
}

extension TodoListItem {
    static func dummy() -> TodoListItem {
        .init(startDate: Date(),
              note: "",
              priority: .high,
              title: "Widget開発")
    }
}

func makeURLScheme(id: UUID) -> URL? {
    guard let url = URL(string: "todolist://detail") else {
        return nil
    }
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = [URLQueryItem(name: "id", value: id.uuidString)]
    return urlComponents?.url
}
