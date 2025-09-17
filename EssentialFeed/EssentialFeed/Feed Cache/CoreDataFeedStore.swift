//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/09/17.
//

import CoreData

public class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    
    public init (bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", in: bundle)
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
}

private extension NSPersistentContainer {
    enum LoadingError: Error {
        case failedToLoadPersistentStores(Error)
    }
    
    static func load(modelName: String, in bundle: Bundle) throws -> NSPersistentContainer {
        let model = try NSManagedObjectModel.with(name: modelName, in: bundle)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
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
