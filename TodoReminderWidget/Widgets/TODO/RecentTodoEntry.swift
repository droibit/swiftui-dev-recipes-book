import Foundation
import WidgetKit

struct RecentTodoEntry: TimelineEntry {
    let date: Date
    let title: String
    let priority: TodoPriority
    let id: UUID

    init(date: Date, title: String, priority: TodoPriority, id: UUID) {
        self.date = date
        self.title = title
        self.priority = priority
        self.id = id
    }

    init(todoItem: TodoListItem) {
        date = todoItem.startDate
        title = todoItem.title
        priority = todoItem.priority
        id = todoItem.id
    }
}

extension RecentTodoEntry {
    static func dummy() -> RecentTodoEntry {
        RecentTodoEntry(date: Date(), title: "Widget開発", priority: .high, id: UUID())
    }
}
