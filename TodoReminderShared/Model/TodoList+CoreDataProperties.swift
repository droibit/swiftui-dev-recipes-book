// swiftlint:disable all

import CoreData
import Foundation

public extension TodoList {
    @nonobjc class func fetchRequest() -> NSFetchRequest<TodoList> {
        NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged var id: UUID?
    @NSManaged var note: String?
    @NSManaged var priority: Int32
    @NSManaged var startDate: Date?
    @NSManaged var title: String?
}

extension TodoList: Identifiable {}
