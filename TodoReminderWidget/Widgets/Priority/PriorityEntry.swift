import WidgetKit

struct PriorityEntry: TimelineEntry {
    let date: Date
    let priority: TodoPriority
    let todoList: [TodoListItem]
}

extension PriorityEntry {
    static func dummy() -> PriorityEntry {
        .init(date: Date(),
              priority: .high,
              todoList: [.dummy(), .dummy(), .dummy()])
    }
}
