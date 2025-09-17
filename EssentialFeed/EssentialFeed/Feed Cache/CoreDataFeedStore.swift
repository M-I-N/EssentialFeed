//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/09/17.
//

import CoreData

public class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init (storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(
            modelName: "FeedStore",
            url: storeURL,
            in: bundle
        )
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let context = self.context
        context.perform {
            let managedCache = ManagedCache(context: context)
            managedCache.timestamp = timestamp
            let managedFeed = feed.map {
                let managed = ManagedFeedImage(context: context)
                managed.id = $0.id
                managed.imageDescription = $0.description
                managed.location = $0.location
                managed.url = $0.url
                return managed
            }
            managedCache.feed = NSSet(array: managedFeed)
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let context = self.context
        context.perform {
            let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
            request.returnsObjectsAsFaults = false
            do {
                if let cache = try context.fetch(request).first {
                    let localFeed = cache.feed
                        .compactMap { $0 as? ManagedFeedImage }
                        .map {
                            LocalFeedImage(
                                id: $0.id,
                                description: $0.imageDescription,
                                location: $0.location,
                                url: $0.url
                            )
                        }
                    completion(
                        .found(
                            feed: localFeed,
                            timestamp: cache.timestamp
                        )
                    )
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case failedToLoadPersistentStores(Error)
    }
    
    static func load(
        modelName: String,
        url: URL,
        in bundle: Bundle
    ) throws -> NSPersistentContainer {
        let model = try NSManagedObjectModel.with(name: modelName, in: bundle)
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: url)]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        try loadError.flatMap { error in
            throw LoadingError.failedToLoadPersistentStores(error)
        }
        
        return container
    }
}

private extension NSManagedObjectModel {
    enum LocationError: Error {
        case noResourceFoundInBundle
        case modelNotFound
    }
    
    static func with(name: String, in bundle: Bundle) throws -> NSManagedObjectModel {
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            throw LocationError.noResourceFoundInBundle
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw LocationError.modelNotFound
        }
        
        return model
    }
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSSet
}

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
