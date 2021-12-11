//
//  Item.swift
//  DemoClassifieds
//
//  Created by Aravind on 09/12/2021.
//

import UIKit

@objcMembers
@objc class Item: NSObject {
    static let placeHolderImage = UIImage(named: "placeholder")
    let createdDate: Date
    let humanReadableDate: String
    let price: String
    let name: String
    let uid: String
    let imageIds: [String]
    let imageUrls: [String]
    let imageThumbnailUrls: [String]
    var cachedImages = [String: UIImage]()
    var cachedThumbnailImages = [String: UIImage]()
    var placeholderImage: UIImage? =  { return placeHolderImage }()
    static var dateFormatter: DateFormatter {
        return defaultDateFormatter()
    }
    
    static func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss.SSSSSS"
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }

    init?(item: Dictionary<String, Any>) {
        guard let createdDate =  item["created_at"] as? String,
              let price = item["price"] as? String,
              let name = item["name"] as? String,
              let uid = item["uid"] as? String,
              let imageIds = item["image_ids"] as? [String],
              let imageUrls = item["image_urls"] as? [String],
              let imageThumbnailUrls = item["image_urls_thumbnails"] as? [String]
              else {
            return nil
        }
        self.createdDate    = Item.dateFormatter.date(from:createdDate) ?? Date()
        self.humanReadableDate = Item.dateFormatter.string(from: self.createdDate)
        self.price          = price
        self.name           = name
        self.uid            = uid
        self.imageIds       = imageIds
        self.imageUrls      = imageUrls
        self.imageThumbnailUrls = imageThumbnailUrls
    }
        
    func set(image: UIImage,key: String)  {
        cachedImages[key] = image
    }
    
    func fullImageId(index: Int) -> String? {
        guard index < imageIds.count else {
            return nil
        }
        let imageId = imageIds[index]
        return "full-image-\(imageId)"
    }

    func thumbnailImageId(index: Int) -> String? {
        guard index < imageIds.count else {
            return nil
        }
        let imageId = imageIds[index]
        return "thumnbnail-image-\(imageId)"
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.uid == rhs.uid
    }

}
