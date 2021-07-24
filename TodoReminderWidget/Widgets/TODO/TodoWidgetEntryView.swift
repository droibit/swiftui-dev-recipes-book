import SwiftUI
import WidgetKit

struct TodoWidgetEntryView: View {
    var entry: TodoProvider.Entry

    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(entry.priority.color)
                .clipShape(ContainerRelativeShape())
                .overlay(
                    Text(entry.title)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(4)
                )

            VStack(alignment: .trailing) {
                Text(entry.date, style: .date)
                Text(entry.date, style: .time)
            }
            .font(.caption)
        }
        .padding(8)
        .widgetURL(makeURLScheme(id: entry.id))
    }
}

struct TodoWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = RecentTodoEntry(
            date: Date(),
            title: "Widget開発",
            priority: .high,
            id: UUID()
        )
        TodoWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
