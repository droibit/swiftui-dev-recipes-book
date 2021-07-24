import SwiftUI
import WidgetKit

@main
struct SampleApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            TodoListView()
                .onChange(of: scenePhase) { newScenePhase in
                    if newScenePhase == .active {
                        WidgetCenter.shared.reloadTimelines(ofKind: "TodoWidget")
                    }
                }
        }
    }
}
