# StructCoreData

This is a demo project to illustrate how to use value typed model in your app data flow, and persist the data as reference typed entity in Core Data.

## Blog

In my daily app development, I like to use Swift struct to build my model, it's value typed, no state issues. This is cool for the most case, but if you want to use Core Data as the persistence layer, you got a problem. How to transfer your struct to Core Data entity, and the reverse way? In this blog, I will try to give a solution.

First, let's see the app we are building. It is a book store app, which has Amazon and Safari two brands. Each store has some books, and the book contains some reviews, you can add or remove a review. All data has been saved in Core Data, for each view, the data is fed by struct model.

[Here comes a git](https://)

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

All Core Data entity will implement `EntityProtocol`, and all struct model will implement `EntityConvertible`.

To be continued ...
