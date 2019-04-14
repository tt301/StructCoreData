# StructCoreData

This is a demo project to illustrate how to use value typed model in your app data flow, and persist the data as reference typed entity in Core Data.

## Blog

In my daily app development, I like to use Swift struct to build my model, it's value typed, no state issues. This is cool for the most case, but if you want to use Core Data as the persistence layer, you got a problem. How to transfer your struct to Core Data entity, and the reverse way? In this blog, I will try to give a solution.

First, let's see the app we are building. It is a book store app, which has Amazon and Safari two brands. Each store has some books, and the book contains some reviews, you can add or remove a review. All data has been saved in Core Data, for each view, the data is fed by struct model.

[Here comes a gif](https://)

The key point for the solution is you need to provide a mechanism to convert struct model to Core Data entity back and forth. So we introduce two protocols:

```swift
protocol EntityProtocol {
    associatedType Model
    func toModel() -> Model
}

protocol EntityConvertible {
    associatedType Entity: NSManagedObject, EntityProtocol
    func toEntity(context: NSManagedObjectContext) -> Entity
}
```

All Core Data entity will implement `EntityProtocol`, and all struct model will implement `EntityConvertible`. Using `BookModel` for example:

```swift
struct BookModel {
    let uuid: String
    var title: String?
    var price: Double?
    var publisher: String?
    var author: AuthorModel?
}

@objc(BookEntity)
public class BookEntity: NSManagedObject {

}

extension BookEntity: EntityProtocol {
    
    func toModel() -> BookModel {
        var book = BookModel(uuid: uuid)
        book.title = title
        book.price = price
        book.publisher = publisher
        book.author = author?.toModel()
        return book
    }
    
}

extension BookModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> BookEntity {
        let book = BookEntity.fetch(with: uuid, in: context)
        book.title = title
        book.price = price ?? 0.0
        book.publisher = publisher
        book.author = author?.toEntity(context: context)
        return book
    }
    
}
```

The `toModel` func is easy to understand, just create a new struct and copy the value. The `toEntity` func needs a trick. We use `uuid` to fetch the object in Core Data context, if has one, we return it, otherwise, we create a new object with that `uuid`, then copy the value to that object.

```swift
extension EntityProtocol where Self: NSManagedObject {
    
    static func fetch(with uuid: String, in context: NSManagedObjectContext) -> Self {
        let fetchRequest = Self.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        fetchRequest.sortDescriptors = nil
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchLimit = 1
        
        var result: [Self]?
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest) as? [Self]
            } catch {
                result = nil
                NSLog("Core Data fetch error: \(error)")
            }
        }
        
        // Return the existing object
        if let object = result?.first {
            return object
        }
        
        // Return the new created one
        let object = Self(context: context)
        object.setValue(uuid, forKey: "uuid")
        return object
    }
    
}
```

The next scenario we need to hanle is One-Many relationship.

To be continued ...
