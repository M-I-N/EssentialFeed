//
//  XCTestCase+Tracking.swift
//  EssentialFeedTests
//
//  Created by Nayem, Mufakkharul | Nil | GSSD on 2024/12/12.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
