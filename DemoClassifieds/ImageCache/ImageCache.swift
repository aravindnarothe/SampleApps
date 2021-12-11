//
//  ImageCache.swift
//  ImageCache
//
//  Created by Aravind on 09/12/2021.
//

import UIKit

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathExtension(path) ?? ""
    }
}

@objcMembers
@objc public final class ImageCache: NSObject {
    private var imageCache = [String: UIImage]()
    let serialQueue = DispatchQueue(label: "com.democlassifieds.cacheSerialQueue")

    static let imageExtension = "png"
    let userDefaults = UserDefaults.standard
    
    public static let sharedInstance = ImageCache()
    override private init() {
        try? CacheDirectoryManager.sharedInstance.createImageCacheDirectory()
    }
    

    public func saveCacheToDisk() {
        for (id, image) in imageCache {
            let imageNameOnDisk = id.stringByAppendingPathComponent(path: ImageCache.imageExtension)
            guard let data = image.pngData(),
                  CacheDirectoryManager.sharedInstance.fileExistsInCacheDirectory(name: imageNameOnDisk) == false
            else {
                continue
            }
            CacheDirectoryManager.sharedInstance.save(data: data, name: imageNameOnDisk)
        }
    }

    public func set(image: UIImage, imageId: String) {
        self.serialQueue.async() { [weak self] in
            self?.imageCache[imageId] = image
        }
    }
    
    public func remove(imageId: String) {
        self.serialQueue.async() { [weak self] in
            self?.imageCache.removeValue(forKey: imageId)
        }
    }
    
    public func getImageCacheURL(id: String) -> String? {
        let cacheDirectoryURL = CacheDirectoryManager.sharedInstance.cacheDirectoryURL()
        return cacheDirectoryURL.appendingPathComponent(id).appendingPathExtension(ImageCache.imageExtension).path
    }
    
    public func getImage(id: String) -> UIImage? {
        if let image = imageCache[id] {
             return image
        }
        let imageNameOnDisk = id.stringByAppendingPathComponent(path: ImageCache.imageExtension)
        if let data = CacheDirectoryManager.sharedInstance.getFile(name: imageNameOnDisk) {
           let image = UIImage(data: data)
            imageCache[id] = image
            return image
        }
        return nil
    }
    
    public func cleanCache() {
        imageCache.removeAll()
        try? CacheDirectoryManager.sharedInstance.deleteImageCacheDirectory()
    }
    
    public func setUpCache() {
        try? CacheDirectoryManager.sharedInstance.createImageCacheDirectory()
    }
}
