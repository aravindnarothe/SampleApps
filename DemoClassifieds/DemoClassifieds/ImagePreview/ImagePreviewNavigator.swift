//
//  ImagePreviewNavigator.swift
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

import Foundation

@objcMembers
@objc class ImagePreviewNavigator: NSObject {
    
    private var navigationController: UINavigationController
    private var image: UIImage

    init(navigationController: UINavigationController, image: UIImage) {
        self.navigationController = navigationController
        self.image = image
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let imagePreviewController = storyboard.instantiateViewController(identifier: "ImagePreviewController") as! ImagePreviewController
        let imagePreviewViewModel = ImagePreviewViewModel(image: image)
        imagePreviewController.viewModel = imagePreviewViewModel
        self.navigationController.present(imagePreviewController, animated: true)
    }

}
