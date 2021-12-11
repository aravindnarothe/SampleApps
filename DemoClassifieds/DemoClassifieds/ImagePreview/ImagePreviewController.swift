//
//  ImagePreviewController.swift
//  DemoClassifieds
//
//  Created by Aravind on 11/12/2021.
//

import Foundation

class ImagePreviewController: UIViewController {
    
    var viewModel: ImagePreviewViewModel?
    @IBOutlet private weak var imageViewer: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }

    private func loadImage() {
        self.imageViewer.image = self.viewModel?.image
    }
    
}
