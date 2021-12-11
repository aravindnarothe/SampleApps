//
//  HomeScreenViewModel.swift
//  DemoClassifiedsTests
//
//  Created by Aravind on 11/12/2021.
//

import Foundation

import XCTest
@testable import DemoClassifieds
@testable import ImageCache

class HomeScreenViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchItemBinding() throws -> HomeScreenViewModel {
        let promise = expectation(description: "items fetch binding works")
        let view = HomeScreenViewController()
        let viewModel = HomeScreenViewModel()
        view.viewModel = viewModel
        viewModel.bind(view: view) { action in
            switch action {
            case .itemsFetched:
                promise.fulfill()
            case .errorFetchingItems(_):
                promise.fulfill()
            default:
                XCTFail("Error: failed to fetch items")
            }
        }
        viewModel.fethItems()
        wait(for: [promise], timeout: 10)
        return viewModel
    }
    
    func testFetchThumbnailBinding() throws {
        let viewModel = try testFetchItemBinding()
        guard let items = viewModel.displayItems else {
            XCTFail("Error: failed to fetch items")
            return
        }
        // pick a random item
        let randomIndex = Int.random(in: 0..<items.count)
        let randomItem = items[randomIndex]
        let randomIndexPath = NSIndexPath(row: randomIndex, section: 0) as IndexPath

        // create dummy view to try if binding works
        let promise = expectation(description: "items fetched")
        let view = HomeScreenViewController()
        view.viewModel = viewModel
        viewModel.bind(view: view) { action in
            switch action {
            case .thumbnailFetched(let indexPath):
                XCTAssertEqual(indexPath, randomIndexPath)
                promise.fulfill()
            default:
                XCTFail("Error: failed to fetch items")
            }
        }
        viewModel.willShow(item: randomItem, at: randomIndexPath)
        viewModel.fetchItemThumbnail(randomItem, randomIndexPath)
        wait(for: [promise], timeout: 10)
    }
    
    func testFilterForItemsIncluded() throws {
        let viewModel = try testFetchItemBinding()
        guard let items = viewModel.displayItems else {
            XCTFail("Error: failed to fetch items")
            return
        }

        // pick a random item
        let randomIndex = Int.random(in: 0..<items.count)
        let randomItem = items[randomIndex]
        let randomSearchText = randomItem.name
        
        
        // create dummy view and view model to try if binding works
        let promise = expectation(description: "items fetched")
        let view = HomeScreenViewController()
        view.viewModel = viewModel
        viewModel.bind(view: view) { action in
            switch action {
            case .itemsFetched:
                guard let filteredItems = viewModel.displayItems else {
                    XCTFail("Error: Filtered result cannot be empty")
                    return
                }
                XCTAssertTrue(filteredItems.contains(randomItem))
                promise.fulfill()
            case .errorFetchingItems(_):
                promise.fulfill()
            default:
                XCTFail("Error: Wrong callback for filtering results")
            }
        }
        viewModel.filter(text: randomSearchText)
        wait(for: [promise], timeout: 10)
    }

    func testFilterForItemsExcsluded() throws {
        let viewModel = try testFetchItemBinding()
        guard let items = viewModel.displayItems else {
            XCTFail("Error: failed to fetch items")
            return
        }

        // pick a random item
        let randomIndex = Int.random(in: 0..<items.count)
        let randomItem = items[randomIndex]
        let randomSearchText = randomItem.name + "corrupt text" // to corrupt search text
        
        
        // create dummy view and view model to try if binding works
        let promise = expectation(description: "items fetched")
        let view = HomeScreenViewController()
        view.viewModel = viewModel
        viewModel.bind(view: view) { action in
            switch action {
            case .itemsFetched:
                guard let filteredItems = viewModel.displayItems else {
                    promise.fulfill()
                    return
                }
                XCTAssertFalse(filteredItems.contains(randomItem))
                promise.fulfill()
            case .errorFetchingItems(_):
                promise.fulfill()
            default:
                XCTFail("Error: Wrong callback for filtering results")
            }
        }
        viewModel.filter(text: randomSearchText)
        wait(for: [promise], timeout: 10)

    }

}
