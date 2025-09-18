//
//  CoreDataHelpers.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/09/18.
//

import CoreData

internal extension NSPersistentContainer {
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

