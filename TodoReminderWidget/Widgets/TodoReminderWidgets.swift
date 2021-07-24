import SwiftUI
import WidgetKit

@main
struct TodoReminderWidgets: WidgetBundle {
    var body: some Widget {
        TodoWidget()
        PriorityWidget()
    }
}
