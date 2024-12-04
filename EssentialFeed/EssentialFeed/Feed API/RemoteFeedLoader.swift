//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/03.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error {
        case connectivity
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: (Error) -> Void = { _ in }) {
        client.get(from: url) { _ in
            completion(.connectivity)
        }
    }
}
