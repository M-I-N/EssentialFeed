//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/02.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
