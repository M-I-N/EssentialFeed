//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/03.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = LoadFeedResult
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteFeedLoader.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data: data, byChecking: response)
            return .success(items.toModels())
        } catch {
            return .failure(Error.invalidData)
        }
    }
}

private extension Array where Element == RemoteFeedItem {
    func toModels() -> [FeedImage] {
        map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.image
            )
        }
    }
}
