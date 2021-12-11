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
    
    func fileExists(name: String) -> Bool {
        let documentsDirectoryPath = getDocumentsDirectory()
        let imagePath = documentsDirectoryPath.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: imagePath.path)
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
        do {
            try data.write(to: imagePath)
        } catch {
            print("Unable to Write Data to Disk (\(error))")
        }
    }

    func getFile(name: String) -> Data? {
        let documentsDirectoryPath = cacheDirectoryURL()
        let imagePath = documentsDirectoryPath.appendingPathComponent(name)
        return try? Data(contentsOf: imagePath)
    }
    
    func createImageCacheDirectory() throws {
        guard fileExists(name: CacheDirectoryManager.imageCacheDirectory) == false else {
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
        guard fileExists(name: CacheDirectoryManager.imageCacheDirectory) == true else {
            return
        }
        try FileManager.default.removeItem(atPath: cacheDirectoryPath())
    }
}
