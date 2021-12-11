//
//  ImageCacheTests.swift
//  DemoClassifiedsTests
//
//  Created by Aravind on 11/12/2021.
//

import XCTest
@testable import ImageCache


class ImageCacheTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let imageCache = ImageCache.sharedInstance
        imageCache.cleanCache()
        imageCache.setUpCache()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetImage() throws {
        guard let dummyImage = UIImage(named: "placeholder") else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let imageCache = ImageCache.sharedInstance
        imageCache.set(image: dummyImage, imageId: dummyname)
        XCTAssertNotNil(imageCache.getImage(id: dummyname), "Save to cache failed")
    }
    
    func testSaveToDisk() throws {
        guard let dummyImage = UIImage(named: "placeholder") else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let imageCache = ImageCache.sharedInstance
        imageCache.set(image: dummyImage, imageId: dummyname)
        imageCache.saveCacheToDisk()
        guard let imageURL = imageCache.getImageCacheURL(id: dummyname) else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        XCTAssertTrue(FileManager.default.fileExists(atPath: imageURL), "Save to disk failed")
    }
    
    func testRemoveImage() throws {
        guard let dummyImage = UIImage(named: "placeholder") else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let imageCache = ImageCache.sharedInstance
        imageCache.set(image: dummyImage, imageId: dummyname)
        imageCache.remove(imageId: dummyname)
        XCTAssertNil(imageCache.getImage(id: dummyname), "Remove from cache failed")
    }

    func testCleanDisk() throws {
        guard let dummyImage = UIImage(named: "placeholder") else {
            XCTFail("Fail: Dummy image missing to proceed test")
            return
        }
        let dummyname = "paceholder"
        let imageCache = ImageCache.sharedInstance
        imageCache.set(image: dummyImage, imageId: dummyname)
        imageCache.cleanCache()
        XCTAssertNil(imageCache.getImage(id: dummyname), "Remove from cache failed")
    }

}
