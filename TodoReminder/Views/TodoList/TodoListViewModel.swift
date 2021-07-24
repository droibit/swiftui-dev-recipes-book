
import Combine
import Foundation

class TodoListViewModel: ObservableObject {
    enum Inputs {
        case onAppear
        case onDismissAddTodo
        case openFromWidget(url: URL)
    }

    @Published var todoList: [TodoListItem] = []
    @Published var activeTodoId: UUID?

    private let todoStore = TodoListStore()

    func apply(inputs: Inputs) {
        switch inputs {
        case .onAppear, .onDismissAddTodo:
            updateTodo()
        case let .openFromWidget(url):
            if let selectedId = getWidgetTodoItemID(from: url) {
                activeTodoId = selectedId
            }
        }
    }

    private func updateTodo() {
        do {
            let list = try todoStore.fetchAll()
            print("list count is \(list.count)")
            todoList = list
        } catch {
            print(error.localizedDescription)
        }
    }

    private func getWidgetTodoItemID(from url: URL) -> UUID? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
              urlComponents.scheme == "todolist",
              urlComponents.host == "detail",
              urlComponents.queryItems?.first?.name == "id",
              let idValue = urlComponents.queryItems?.first?.value
        else {
            return nil
        }
        return UUID(uuidString: idValue)
    }
}
