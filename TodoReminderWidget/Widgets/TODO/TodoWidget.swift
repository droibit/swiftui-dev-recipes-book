import SwiftUI
import WidgetKit

struct TodoProvider: TimelineProvider {
    typealias Entry = RecentTodoEntry

    func placeholder(in context: Context) -> Entry {
        RecentTodoEntry(date: Date(), title: "Widget開発", priority: .high, id: UUID())
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        guard !context.isPreview else {
            completion(.dummy())
            return
        }

        let emptyEntry = RecentTodoEntry(date: Date(), title: "Todoはありません", priority: .low, id: UUID())
        do {
            let store = TodoListStore()
            let todoLists = try store.fetchTodayItems()
            let entries = todoLists.map(RecentTodoEntry.init)
            completion(entries.first ?? emptyEntry)
        } catch {
            print(error.localizedDescription)
            completion(emptyEntry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let emptyEntry = RecentTodoEntry(date: Date(), title: "Todoはありません", priority: .low, id: UUID())
        do {
            let store = TodoListStore()
//            let todoLists = try store.fetchTodayItems()
            let todoLists = try store.fetchAll()
            var entries = todoLists.map(RecentTodoEntry.init)
            if entries.isEmpty {
                entries.append(emptyEntry)
            }
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } catch {
            print(error.localizedDescription)
            let timeline = Timeline(entries: [emptyEntry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodoProvider()) { entry in
            TodoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo Reminder")
        .description("直近のTodoListをお知らせします")
        .supportedFamilies([.systemSmall])
    }
}
