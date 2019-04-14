//
//  CoreDataStack.swift
//  StructCoreData
//
//  Created by Tian Tong on 2019/4/12.
//  Copyright © 2019 Tian Tong. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "StructCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        viewContext.perform {
            block(self.viewContext)
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataStack {
    
    func resetData() {
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap ({ $0.name }).forEach(clearEntity)
        
        createDummyData()
        
        NSLog("Core Data reset")
        NotificationCenter.default.post(name: NSNotification.Name("Reload"), object: nil)
    }
    
    private func clearEntity(_ name: String) {
        let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let batchDelete = NSBatchDeleteRequest(fetchRequest: deleteRequest)
        
        do {
            try viewContext.execute(batchDelete)
        } catch {
            NSLog("Batch delete error for \(name): \(error)")
        }
    }
    
    private func createDummyData() {
        let amazonStore = StoreEntity(context: viewContext)
        amazonStore.uuid = UUID().uuidString
        amazonStore.brand = "Amazon Books"
        
        let safariStore = StoreEntity(context: viewContext)
        safariStore.uuid = UUID().uuidString
        safariStore.brand = "Safari Books Online"
        
        let charles = AuthorEntity(context: viewContext)
        charles.uuid = UUID().uuidString
        charles.name = "Charles Duhigg"
        
        let thePowerOfHabit = BookEntity(context: viewContext)
        thePowerOfHabit.uuid = UUID().uuidString
        thePowerOfHabit.title = "The Power of Habit"
        thePowerOfHabit.price = 13.60
        thePowerOfHabit.publisher = "Random House"
        thePowerOfHabit.author = charles
        
        let nassim = AuthorEntity(context: viewContext)
        nassim.uuid = UUID().uuidString
        nassim.name = "Nassim Nicholas Taleb"
        
        let theBlackSwan = BookEntity(context: viewContext)
        theBlackSwan.uuid = UUID().uuidString
        theBlackSwan.title = "The Black Swan"
        theBlackSwan.price = 12.23
        theBlackSwan.publisher = "Random House"
        theBlackSwan.author = nassim
        
        amazonStore.addToBooks(thePowerOfHabit)
        amazonStore.addToBooks(theBlackSwan)
        
        let chris = AuthorEntity(context: viewContext)
        chris.uuid = UUID().uuidString
        chris.name = "Chris Eidhof"
        
        let advancedSwift = BookEntity(context: viewContext)
        advancedSwift.uuid = UUID().uuidString
        advancedSwift.title = "Advanced Swift"
        advancedSwift.price = 39.00
        advancedSwift.publisher = "Createspace Independent Pub"
        advancedSwift.author = chris
        
        let functionalSwift = BookEntity(context: viewContext)
        functionalSwift.uuid = UUID().uuidString
        functionalSwift.title = "Functional Swift"
        functionalSwift.price = 47.00
        functionalSwift.publisher = "Florian Kugler"
        functionalSwift.author = chris
        
        let florian = AuthorEntity(context: viewContext)
        florian.uuid = UUID().uuidString
        florian.name = "Florian Kugler"
        
        let coreData = BookEntity(context: viewContext)
        coreData.uuid = UUID().uuidString
        coreData.title = "Core Data"
        coreData.price = 39.00
        coreData.publisher = "Createspace Independent Pub"
        coreData.author = florian
        
        safariStore.addToBooks(advancedSwift)
        safariStore.addToBooks(functionalSwift)
        safariStore.addToBooks(coreData)
        
        let userA = UserEntity(context: viewContext)
        userA.uuid = UUID().uuidString
        userA.name = "User A"
        userA.email = "a@user.com"
        
        let userB = UserEntity(context: viewContext)
        userB.uuid = UUID().uuidString
        userB.name = "User B"
        userB.email = "b@user.com"
        
        let userC = UserEntity(context: viewContext)
        userC.uuid = UUID().uuidString
        userC.name = "User C"
        userC.email = "c@user.com"
        
        let userD = UserEntity(context: viewContext)
        userD.uuid = UUID().uuidString
        userD.name = "User D"
        userD.email = "d@user.com"
        
        let userE = UserEntity(context: viewContext)
        userE.uuid = UUID().uuidString
        userE.name = "User E"
        userE.email = "e@user.com"
        
        let theBlackSwanReviewA = ReviewEntity(context: viewContext)
        theBlackSwanReviewA.uuid = UUID().uuidString
        theBlackSwanReviewA.content = "I am not smart enough to estimate the number of people who have been given the capacity to look at the world from an entirely unique and yet vital perspective, but Nassim Taleb is definitely one of them."
        theBlackSwanReviewA.createdAt = Date()
        theBlackSwanReviewA.user = userE
        
        let theBlackSwanReviewB = ReviewEntity(context: viewContext)
        theBlackSwanReviewB.uuid = UUID().uuidString
        theBlackSwanReviewB.content = "I am not sure how to describe it, but reading this book is definitely an Experience."
        theBlackSwanReviewB.createdAt = Date()
        theBlackSwanReviewB.user = userD
        
        theBlackSwan.addToReviews(theBlackSwanReviewA)
        theBlackSwan.addToReviews(theBlackSwanReviewB)
        
        let thePowerOfHabitReviewA = ReviewEntity(context: viewContext)
        thePowerOfHabitReviewA.uuid = UUID().uuidString
        thePowerOfHabitReviewA.content = "Best seller for New York Times, Los Angeles Times, US Today."
        thePowerOfHabitReviewA.createdAt = Date()
        thePowerOfHabitReviewA.user = userB
        
        let thePowerOfHabitReviewB = ReviewEntity(context: viewContext)
        thePowerOfHabitReviewB.uuid = UUID().uuidString
        thePowerOfHabitReviewB.content = "This book helps us understand how habits are formed and how we can use them to our benefit, change them when we need to and replace them when necessary."
        thePowerOfHabitReviewB.createdAt = Date()
        thePowerOfHabitReviewB.user = userD
        
        thePowerOfHabit.addToReviews(thePowerOfHabitReviewA)
        thePowerOfHabit.addToReviews(thePowerOfHabitReviewB)
        
        let coreDataReviewA = ReviewEntity(context: viewContext)
        coreDataReviewA.uuid = UUID().uuidString
        coreDataReviewA.content = "Core Data is cool"
        coreDataReviewA.createdAt = Date()
        coreDataReviewA.user = userA
        
        let coreDataReviewB = ReviewEntity(context: viewContext)
        coreDataReviewB.uuid = UUID().uuidString
        coreDataReviewB.content = "Core Data could do the data persistency work, but it's power is more than that."
        coreDataReviewB.createdAt = Date()
        coreDataReviewB.user = userB
        
        let coreDataReviewC = ReviewEntity(context: viewContext)
        coreDataReviewC.uuid = UUID().uuidString
        coreDataReviewC.content = "I like to use Core Data, but I want my models are value typed."
        coreDataReviewC.createdAt = Date()
        coreDataReviewC.user = userA
        
        coreData.addToReviews(coreDataReviewA)
        coreData.addToReviews(coreDataReviewB)
        coreData.addToReviews(coreDataReviewC)
        
        let functionalSwiftReviewA = ReviewEntity(context: viewContext)
        functionalSwiftReviewA.uuid = UUID().uuidString
        functionalSwiftReviewA.content = "Swift language supports functional programming."
        functionalSwiftReviewA.createdAt = Date()
        functionalSwiftReviewA.user = userA
        
        let functionalSwiftReviewB = ReviewEntity(context: viewContext)
        functionalSwiftReviewB.uuid = UUID().uuidString
        functionalSwiftReviewB.content = "This is the advanced feature in Swift."
        functionalSwiftReviewB.createdAt = Date()
        functionalSwiftReviewB.user = userB
        
        functionalSwift.addToReviews(functionalSwiftReviewA)
        functionalSwift.addToReviews(functionalSwiftReviewB)
        
        let advancedSwiftReviewA = ReviewEntity(context: viewContext)
        advancedSwiftReviewA.uuid = UUID().uuidString
        advancedSwiftReviewA.content = "Talk about advanced concepts in Swift programming."
        advancedSwiftReviewA.createdAt = Date()
        advancedSwiftReviewA.user = userC
        
        advancedSwift.addToReviews(advancedSwiftReviewA)
        
        saveContext()
    }
    
}
