import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var priority: Int32
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?

}

extension TodoList : Identifiable {

}
