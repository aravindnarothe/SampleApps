//
//  CacheDirectoryManagerTests.swift
//  DemoClassifiedsTests
//
//  Created by Aravind on 11/12/2021.
//

import Foundation

import XCTest
@testable import ImageCache


class CacheDirectoryManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let cacheDirectoryManager = CacheDirectoryManager.sharedInstance
        try? cacheDirectoryManager.deleteImageCacheDirectory()
        try? cacheDirectoryManager.createImageCacheDirectory()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateImageCacheDirectory() throws {
        let cacheDirectoryManager = CacheDirectoryManager.sharedInstance
        try? cacheDirectoryManager.createImageCacheDirectory()
        XCTAssertTrue(cacheDirectoryManager.fileExistsInDocumentsDirectory(name: CacheDirectoryManager.imageCacheDirectory))
    }

    func testDeleteImageCacheDirectory() throws {
        let cacheDirectoryManager = CacheDirectoryManager.sharedInstance
        try? cacheDirectoryManager.deleteImageCacheDirectory()
        XCTAssertFalse(cacheDirectoryManager.fileExistsInDocumentsDirectory(name: CacheDirectoryManager.imageCacheDirectory))
    }
    
    func testSaveData() throws {
        guard let dummyImage = UIImage(named: "placeholder"),
              let data = dummyImage.pngData()
        else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let cacheDirectoryManager = CacheDirectoryManager.sharedInstance
        cacheDirectoryManager.save(data: data, name: dummyname)
        XCTAssertTrue(cacheDirectoryManager.fileExistsInCacheDirectory(name: dummyname))
    }

    func testGetFile() throws {
        guard let dummyImage = UIImage(named: "placeholder"),
              let data = dummyImage.pngData()
        else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let cacheDirectoryManager = CacheDirectoryManager.sharedInstance
        cacheDirectoryManager.save(data: data, name: dummyname)
        XCTAssertNotNil(cacheDirectoryManager.getFile(name: dummyname))
    }

    
}
