# StructCoreData

This is a demo project to illustrate how to use value typed model in your app data flow, and persist the data as reference typed entity in Core Data.

## Blog

In my daily app development, I like to use Swift struct to build my model. It's value typed, no states issues. This is cool for the most case. But if you want to use Core Data as the persistence layer, you need to think more, how to transfer your struct to Core Data entity, and in the reverse way? In this blog, I will try to give a solution.

First, let's see the app we are building. It is a book store app, which has Amazon and Safari two brands. Each store has some books, and the book contains some reviews, you can add or remove a review. All data is persisted in Core Data, for each view, the business data flow is handled by struct model.

![Here comes a gif](ProjectDemo.gif)

The key point of the solution is a mechanism for converting struct model to Core Data entity back and forth. So we introduce two protocols:

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

The next scenario we need to handle is *One-Many* relationship. There are two ways to implement it, the first way is let the *One* hold the ownership, it contains an array of *Many*. The second way is let each of *Many* hold a back reference to the *One*. Which way should be adopted is really depends on your business workflow. 

Let's see the *One* holds the ownership first, using `StoreModel` for example:

```swift
struct StoreModel {
    let uuid: String
    var brand: String?
    var books: [BookModel]?
}

extension StoreEntity: EntityProtocol {
    
    func toModel() -> StoreModel {
        var store = StoreModel(uuid: uuid)
        store.brand = brand
        store.books = books?.compactMap { $0.toModel() }
        return store
    }
    
}

extension StoreModel: EntityConvertible {
    
    func toEntity(context: NSManagedObjectContext) -> StoreEntity {
        let store = StoreEntity.fetch(with: uuid, in: context)
        store.brand = brand
        store.books = Set(books?.compactMap { $0.toEntity(context: context) } ?? [])
        return store
    }
    
}
```

For both directions, we use `Array` or `Set` to hold *Many* relationship. From `StoresViewController` to `BooksViewController`, the `store` property will be passed, which contains the books to display. In app business data flow, we always using struct model to define api. Such as `BooksDataModelProtocol`:

```swift
protocol BooksDataModelProtocol {
    var store: StoreModel { get }
    func fetchBooks(completion: @escaping ([BookModel]) -> Void)
}
```

Now, let's take a look at another approach - back reference. We use `BookModel` and `ReviewModel` for example. Each book could has some reviews, but I don't want the book holds all reviews by itself, instead, I think each review holds a book reference is much better, so the `bookId` property has been added in `ReviewModel`.

```swift
struct BookModel {
    let uuid: String
    var title: String?
    var price: Double?
    var publisher: String?
    var author: AuthorModel?
}

struct ReviewModel {
    let uuid: String
    var bookId: String?
    var content: String?
    var createdAt: Date?
    var user: UserModel?
}
```

When comes to `ReviewsViewController`, all reviews will be fetched through `bookId` filter.

```swift
func fetchReviews(completion: @escaping ([ReviewModel]) -> Void) {
    let predicate = NSPredicate(format: "bookId == %@", book.uuid)
    let sort = NSSortDescriptor(key: "createdAt", ascending: true)
    
    coreData.fetch(with: predicate, sortDescriptors: [sort]) { (result: Result<[ReviewModel]>) in
        switch result {
        case .success(let items):
            completion(items)
        case .failure(let error):
            completion([])
            NSLog(error.localizedDescription)
        }
    }
}
```

Now we need to handle how to send struct model to do CRUD operations in Core Data. To achieve this, we introduce `CoreDataServiceProtocol`. Create and update will be handled by `update` func, read will be handled by `fetch` func, and delete will be handled by `delete` func.

```swift
protocol CoreDataServiceProtocol {
    func fetch<Model: EntityConvertible>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: @escaping (Result<[Model]>) -> Void)
    func update<Model: EntityConvertible>(entities: [Model], completion: @escaping (Error?) -> Void)
    func delete<Model: EntityConvertible>(entities: [Model], completion: @escaping (Error?) -> Void)
}
```

The last thing I want to mention is we need to handle state changes manully now, because every view's data is value typed struct. This really needs some extra work, but I am happy to accept it.

Yeah, that's it. Enjoy with the demo project.
