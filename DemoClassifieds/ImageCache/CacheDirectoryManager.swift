//
//  FileManager.swift
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

import UIKit

final class CacheDirectoryManager {
    
    static let sharedInstance = CacheDirectoryManager()
    static let imageCacheDirectory = "ImageCache"

    private init() {}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fileExistsInDocumentsDirectory(name: String) -> Bool {
        let documentsDirectoryPath = getDocumentsDirectory()
        let filePath = documentsDirectoryPath.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: filePath.path)
    }

    func fileExistsInCacheDirectory(name: String) -> Bool {
        let cacheDirectoryPath = cacheDirectoryURL()
        let filePath = cacheDirectoryPath.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: filePath.path)
    }

    func cacheDirectoryURL() -> URL {
        let documentsDirectoryPath = getDocumentsDirectory()
        return documentsDirectoryPath.appendingPathComponent(CacheDirectoryManager.imageCacheDirectory)
    }
    
    func cacheDirectoryPath() -> String {
        return cacheDirectoryURL().path
    }
    
    func save(data: Data, name: String) {
        let cacheDirectoryPath = cacheDirectoryURL()
        let imagePath = cacheDirectoryPath.appendingPathComponent(name)
        try? data.write(to: imagePath)
    }

    func getFile(name: String) -> Data? {
        let documentsDirectoryPath = cacheDirectoryURL()
        let imagePath = documentsDirectoryPath.appendingPathComponent(name)
        return try? Data(contentsOf: imagePath)
    }
    
    func createImageCacheDirectory() throws {
        guard fileExistsInDocumentsDirectory(name: CacheDirectoryManager.imageCacheDirectory) == false else {
            return
        }
        do {
            try FileManager.default.createDirectory(
                atPath: cacheDirectoryPath(),
                withIntermediateDirectories: false,
                attributes: nil)
        } catch  {
            print("\(error.localizedDescription)")
        }
    }
    
    func deleteImageCacheDirectory() throws {
        guard fileExistsInDocumentsDirectory(name: CacheDirectoryManager.imageCacheDirectory) == true else {
            return
        }
        try FileManager.default.removeItem(atPath: cacheDirectoryPath())
    }
}
