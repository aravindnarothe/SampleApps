//
//  ItemCell.swift
//  DemoClassifieds
//
//  Created by Aravind on 10/12/2021.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet private weak var itemThumbnail: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    var itemId: String?
    
    
    func setItem(item: Item) {
        priceLabel.text = item.price
        nameLabel.text = item.name
        itemId = item.uid
        if let imageId = item.thumbnailImageId(index: 0),
           let cachedImage = item.cachedThumbnailImages[imageId] {
            itemThumbnail.image = cachedImage
        } else {
            itemThumbnail.image = item.placeholderImage
        }
    }
    
    func set(image: UIImage)  {
        spinner.stopAnimating()
        itemThumbnail.image = image
    }
}
