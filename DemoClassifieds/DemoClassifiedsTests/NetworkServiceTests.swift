//
//  DemoClassifiedsTests.swift
//  DemoClassifiedsTests
//
//  Created by Aravind on 09/12/2021.
//

import XCTest
@testable import DemoClassifieds
@testable import ImageCache

class NetworkServiceTests: XCTestCase {
    
    var items: [Item]?
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchItemsURL() throws {
        let itemsUrl = itemsUrl
        let networkService = NetworkService()
        let promise = expectation(description: "results fetched")
        networkService.fetchItems(url: itemsUrl) { [weak self] items, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            self?.items = items
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func testFetchThumbnailImage() throws -> Item? {
        try? testFetchItemsURL()
        guard let items = items else {
            XCTFail("Error: items missing")
            return nil
        }
        let promise = expectation(description: "thumbnail fetched")
        var randomIndex = Int.random(in: 0..<items.count)
        let randomItem = items[randomIndex]
        guard randomItem.imageThumbnailUrls.count > 0  else {
            XCTFail("Error: Thumbnail image url missing")
            return nil
        }
        let imageId = randomItem.thumbnailImageId(index: 0) ?? ""
        guard imageId.count > 0  else {
            XCTFail("Error: Thumbnail image id missing")
            return nil
        }
        randomIndex = Int.random(in: 0..<randomItem.imageThumbnailUrls.count)
        let thumbnailUrl = randomItem.imageThumbnailUrls[randomIndex]
        let networkService = NetworkService()
        networkService.fetchImage(id: imageId, url: thumbnailUrl) { image, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        return randomItem
    }

    func testFetchFullImage() throws -> (Item, Int)? {
        try? testFetchItemsURL()
        guard let items = items else {
            XCTFail("Error: items missing")
            return nil
        }
        let promise = expectation(description: "full image fetched")
        var randomIndex = Int.random(in: 0..<items.count)
        let randomItem = items[randomIndex]
        guard randomItem.imageUrls.count > 0  else {
            XCTFail("Error: image url missing")
            return nil
        }
        let imageId = randomItem.fullImageId(index: 0) ?? ""
        guard imageId.count > 0  else {
            XCTFail("Error: image id missing")
            return nil
        }
        randomIndex = Int.random(in: 0..<randomItem.imageUrls.count)
        let thumbnailUrl = randomItem.imageUrls[randomIndex]
        let networkService = NetworkService()
        networkService.fetchImage(id: imageId, url: thumbnailUrl) { image, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        return (randomItem, randomIndex)
    }
    
    func testFetchAndSaveToCacheThumbnailImage() throws {
        guard let item = try testFetchThumbnailImage() else {
            return
        }
        let imageId = item.thumbnailImageId(index: 0)
        guard let imageId = imageId else {
            XCTFail("Error: image id missing")
            return
        }
        let imageCache = ImageCache.sharedInstance.getImage(id: imageId)
        XCTAssertNotNil(imageCache)
        
    }

    func testFetchAndSaveToCacheFullImage() throws {
        guard let (item, index) = try testFetchFullImage() else {
            return
        }
        let imageId = item.fullImageId(index: index)
        guard let imageId = imageId else {
            XCTFail("Error: image id missing")
            return
        }
        let imageCache = ImageCache.sharedInstance.getImage(id: imageId)
        XCTAssertNotNil(imageCache)
    }

}
