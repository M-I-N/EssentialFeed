//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/12/03.
//

import XCTest

final class FeedViewController {
    init (loader: FeedViewControllerTests.LoaderSpy) {
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
    
}
