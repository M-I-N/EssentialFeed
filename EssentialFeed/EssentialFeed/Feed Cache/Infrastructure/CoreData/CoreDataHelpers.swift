//
//  CoreDataHelpers.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/09/18.
//

import CoreData

extension NSPersistentContainer {
    static func load(
        name: String,
        model: NSManagedObjectModel,
        url: URL
    ) throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: url)]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        try loadError.flatMap { error in
            throw error
        }
        
        return container
    }
}

extension NSManagedObjectModel {
    convenience init?(name: String, in bundle: Bundle) {
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            return nil
        }
        
        self.init(contentsOf: url)
    }
}

