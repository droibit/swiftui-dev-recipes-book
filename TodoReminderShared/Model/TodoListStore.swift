import CoreData
import Foundation

struct TodoListItem: Identifiable {
    var startDate: Date
    var note: String
    var priority: TodoPriority
    var title: String
    var id = UUID()
}

enum CoreDataStoreError: Error {
    case failureFetch
}

enum TodoPriority: Int {
    case low = 0
    case medium = 1
    case high = 2

    var name: String {
        switch self {
        case .high:
            return "高"
        case .medium:
            return "中"
        case .low:
            return "低"
        }
    }
}

extension TodoList {
    func convert() -> TodoListItem? {
        guard let startDate = startDate,
              let note = note,
              let priority = TodoPriority(rawValue: Int(priority)),
              let title = title,
              let id = id else { return nil }
        return TodoListItem(
            startDate: startDate,
            note: note,
            priority: priority,
            title: title,
            id: id
        )
    }
}

final class TodoListStore {
    typealias Entity = TodoList

    static let containerName: String = "Todo"
    static let entityName: String = "TodoList"

    func insert(item: TodoListItem) throws {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: TodoListStore.entityName, into: persistentContainer.viewContext) as? Entity
        newItem?.startDate = item.startDate
        newItem?.note = item.note
        newItem?.priority = Int32(item.priority.rawValue)
        newItem?.title = item.title
        newItem?.id = item.id
        try saveContext()
    }

    func fetchAll() throws -> [TodoListItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TodoListStore.entityName)
        do {
            guard let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [Entity] else {
                throw CoreDataStoreError.failureFetch
            }
            let todoList = result.compactMap { $0.convert() }
            return todoList
        } catch {
            throw error
        }
    }

    func fetchTodayItems() throws -> [TodoListItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TodoListStore.entityName)
        fetchRequest.predicate = makeTodayItemsPredicate()
        do {
            guard let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [Entity] else {
                throw CoreDataStoreError.failureFetch
            }
            let todoList = result.compactMap { $0.convert() }
            return todoList
        } catch {
            throw error
        }
    }

    func fetch(by uuid: UUID) throws -> TodoListItem {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TodoListStore.entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        do {
            guard let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [Entity] else {
                throw CoreDataStoreError.failureFetch
            }
            let todoList = result.compactMap { $0.convert() }
            guard let todo = todoList.first else {
                throw CoreDataStoreError.failureFetch
            }
            return todo
        } catch {
            throw error
        }
    }

    func fetchTodayItems(by priorityValue: Int) throws -> [TodoListItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TodoListStore.entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            makeTodayItemsPredicate(),
            NSPredicate(format: "priority == %d", priorityValue),
        ])
        do {
            guard let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [Entity] else {
                throw CoreDataStoreError.failureFetch
            }
            let todoList = result.compactMap { $0.convert() }
            return todoList
        } catch {
            throw error
        }
    }

    private func makeTodayItemsPredicate() -> NSPredicate {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)!
        return NSPredicate(format: "startDate >= %@ AND startDate =< %@", argumentArray: [now, endDate])
    }

    func delete(item: TodoList) throws {
        persistentContainer.viewContext.delete(persistentContainer.viewContext.object(with: item.objectID))
        try saveContext()
    }

    // MARK: - private

    // https://stackoverflow.com/questions/41684256/accessing-core-data-from-both-container-app-and-extension
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: TodoListStore.containerName)
        container
            .persistentStoreDescriptions =
            [NSPersistentStoreDescription(url: FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.github.droibit.example.TodoReminder")!
                    .appendingPathComponent("\(TodoListStore.containerName).sqlite"))]
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                throw nserror
            }
        }
    }
}
