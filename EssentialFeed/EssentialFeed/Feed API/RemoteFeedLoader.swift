//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/03.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
