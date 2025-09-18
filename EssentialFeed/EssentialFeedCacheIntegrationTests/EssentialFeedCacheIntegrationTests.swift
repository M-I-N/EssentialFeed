//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2025/09/18.
//

import XCTest
import EssentialFeed

final class EssentialFeedCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnASeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let feed = uniqueImageFeed().models
        
        let saveExp = expectation(description: "Wait for save completion")
        sutToPerformSave.save(feed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            saveExp.fulfill()
        }
        wait(for: [saveExp], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: feed)
    }
    
    func test_load_overridesItemsSavedOnASeparateInstance() {
        let sutToPerformInitialSave = makeSUT()
        let sutToPerformLatestSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models
        
        let firstSaveExp = expectation(description: "Wait for first save completion")
        sutToPerformInitialSave.save(firstFeed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            firstSaveExp.fulfill()
        }
        wait(for: [firstSaveExp], timeout: 1.0)
        
        let latestSaveExp = expectation(description: "Wait for latest save completion")
        sutToPerformLatestSave.save(latestFeed) { saveError in
            XCTAssertNil(saveError, "Expected to save feed successfully")
            latestSaveExp.fulfill()
        }
        wait(for: [latestSaveExp], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: latestFeed)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LocalFeedLoader {
        let bundle = Bundle(for: CoreDataFeedStore.self)
        let store = try! CoreDataFeedStore(storeURL: testSpecificStoreURL(), bundle: bundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: LocalFeedLoader,
        toLoad expectedFeed: [FeedImage],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { result in
            switch result {
            case let .success(loadedFeed):
                XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful image feed result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(String(describing: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first!
    }
    
}
