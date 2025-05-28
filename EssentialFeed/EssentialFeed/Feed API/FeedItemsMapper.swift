//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/06.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

enum FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static func map(
        _ data: Data,
        _ response: HTTPURLResponse
    ) throws -> [RemoteFeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(
            Root.self,
            from: data
        )
        
        return root.items
    }
    
    static func map(
        data: Data,
        byChecking response: HTTPURLResponse
    ) throws -> [RemoteFeedItem] {
        let items = try FeedItemsMapper.map(data, response)
        return items
    }
}
