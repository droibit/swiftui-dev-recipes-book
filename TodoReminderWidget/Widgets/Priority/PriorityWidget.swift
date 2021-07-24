import SwiftUI
import WidgetKit

struct PriorityProvider: IntentTimelineProvider {
    typealias Intent = PrioritySelectionIntent
    typealias Entry = PriorityEntry

    func placeholder(in context: Context) -> PriorityEntry {
        .dummy()
    }

    func getSnapshot(
        for configuration: PrioritySelectionIntent,
        in context: Context,
        completion: @escaping (PriorityEntry) -> Void
    ) {
        guard !context.isPreview else {
            completion(.dummy())
            return
        }
        let todoList = try! fetchPriority(for: configuration)
        guard let priorityValue = configuration.priority?.intValue,
              let priority = TodoPriority(rawValue: priorityValue)
        else {
            let entry = PriorityEntry(date: Date(), priority: .low, todoList: [])
            completion(entry)
            return
        }
        let entry = PriorityEntry(date: Date(), priority: priority, todoList: todoList)
        completion(entry)
    }

    private func fetchPriority(for configuration: PrioritySelectionIntent) throws -> [TodoListItem] {
        if let priorityValue = configuration.priority?.intValue {
            let store = TodoListStore()
            do {
                return try store.fetchTodayItems(by: priorityValue)
            } catch {
                throw error
            }
        } else {
            throw CoreDataStoreError.failureFetch
        }
    }

    func getTimeline(
        for configuration: PrioritySelectionIntent,
        in context: Context,
        completion: @escaping (Timeline<PriorityEntry>) -> Void
    ) {
        do {
            let todoList = try fetchPriority(for: configuration)
            print("priority: \(todoList.description)")
            var entries: [PriorityEntry] = []
            divideByThree(todoList: todoList).forEach { todoList in
                if let lastTodo = todoList.last {
                    entries.append(
                        PriorityEntry(
                            date: lastTodo.startDate,
                            priority: lastTodo.priority,
                            todoList: todoList
                        )
                    )
                } else {
                    let selectedPriority = TodoPriority(rawValue: configuration.priority!.intValue)!
                    entries.append(
                        PriorityEntry(
                            date: Date(),
                            priority: selectedPriority,
                            todoList: []
                        )
                    )
                }
            }
            let timeLine = Timeline(entries: entries, policy: .atEnd)
            completion(timeLine)
        } catch {
            print(error.localizedDescription)
            let entry = PriorityEntry(date: Date(), priority: .low, todoList: [])
            let timeLine = Timeline(entries: [entry], policy: .never)
            completion(timeLine)
        }
    }

    private func divideByThree(todoList: [TodoListItem]) -> [[TodoListItem]] {
        stride(from: 0, to: todoList.count, by: 3).map {
            Array(todoList[$0 ..< min($0 + 3, todoList.count)])
        }
    }
}

struct PriorityWidget: Widget {
    let kind: String = "PriorityWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: PrioritySelectionIntent.self,
            provider: PriorityProvider()
        ) { entry in
            PriorityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Priority Sort")
        .description("今日のTodoを優先度ごとに表示")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
