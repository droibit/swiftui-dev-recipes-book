import SwiftUI
import WidgetKit

struct PriorityWidgetEntryView: View {
    let entry: PriorityProvider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            makeSmallView()
        case .systemMedium:
            makeMediumlView()
        default:
            EmptyView()
        }
    }

    private func makeSmallView() -> some View {
        VStack {
            if let todo = entry.todoList.first {
                HStack(spacing: 4) {
                    PriorityCircle(priority: todo.priority)

                    VStack(alignment: .leading) {
                        TodoCell(todoTitle: todo.title)
                    }
                }
                .widgetURL(makeURLScheme(id: todo.id))
            } else {
                Text("今日のTodoはありません")
                    .padding(.bottom)
            }

            Text(entry.date, style: .date)
                .font(.footnote)
        }
        .padding()
    }

    private func makeMediumlView() -> some View {
        HStack {
            Rectangle()
                .foregroundColor(entry.priority.color)
                .overlay(
                    VStack {
                        Text("今日のTodo")
                            .fontWeight(.bold)
                        Text("優先度: \(entry.priority.name)")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                )

            if entry.todoList.isEmpty {
                Text("今日のTodoはありません")
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    ForEach(entry.todoList) { todoItem in
                        Link(destination: makeURLScheme(id: todoItem.id)!) {
                            TodoMediumCell(todoTitle: todoItem.title, startDate: todoItem.startDate)
                        }
                    }
                    Text(entry.date, style: .date)
                        .font(.footnote)
                }
            }
        }
    }
}

struct TodoCell: View {
    let todoTitle: String
    var body: some View {
        VStack(spacing: 8) {
            Text(todoTitle)
                .font(.title3)
            Divider()
        }
    }
}

struct TodoMediumCell: View {
    let todoTitle: String
    let startDate: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(todoTitle)
                Text(startDate, style: .time)
                    .font(.caption)
            }
            Divider()
        }
    }
}

struct PriorityCircle: View {
    let priority: TodoPriority
    var body: some View {
        Circle()
            .foregroundColor(priority.color)
            .frame(width: 20, height: 30)
    }
}

struct PriorityWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PriorityWidgetEntryView(entry: .dummy())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            PriorityWidgetEntryView(entry: .dummy())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            PriorityWidgetEntryView(entry: .dummy())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            PriorityWidgetEntryView(entry: .dummy())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
