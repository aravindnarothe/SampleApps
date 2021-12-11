//
//  HomeScreenViewModel.swift
//  DemoClassifieds
//
//  Created by Aravind on 10/12/2021.
//

import UIKit

enum HomeScreenStates {
    case itemsFetched
    case errorFetchingItems(NetworkError?)
    case thumbnailFetched(IndexPath)
}

typealias HomeScreenViewUpdate = (HomeScreenStates) -> Void

final class HomeScreenViewModel {
    
    private var items: [Item]?
    var displayItems: [Item]?

    private weak var homeScreenViewController: HomeScreenViewController?
    private var viewUpdateBlock: HomeScreenViewUpdate?
    private var networkRequests = [String: NetworkService]()
    private var indexpathMap = [IndexPath: String]()
    
    
    func bind(view: HomeScreenViewController, action: @escaping HomeScreenViewUpdate) {
        homeScreenViewController = view
        viewUpdateBlock = action
    }
    
    private func post(state: HomeScreenStates) {
        DispatchQueue.main.async { [weak self] in
            self?.viewUpdateBlock?(state)
        }
    }
    
    func willShow(item: Item, at indexPath: IndexPath)  {
        let url = item.imageThumbnailUrls[0];
        indexpathMap[indexPath] = url
    }
    
    func fethItems() {
        let networkService = NetworkService()
        networkRequests[itemsUrl] = networkService
        networkService.fetchItems(url: itemsUrl) { [weak self] items, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.post(state: .errorFetchingItems(error!))
                return
            }
            guard let items = items else {
                strongSelf.post(state: .errorFetchingItems(nil))
                return
            }
            strongSelf.networkRequests.removeValue(forKey: itemsUrl)
            strongSelf.items = items
            strongSelf.displayItems = items
            strongSelf.post(state: .itemsFetched)
        }
    }
    
    private func thumbnailFetched(
        item: Item,
        _ indexPath: IndexPath,
        url: String,
        image: UIImage?,
        error: NetworkError?,
        needsReload: Bool
    ) {
        guard error == nil else {
            return
        }
        guard let image = image else {
            return
        }
        let item = item
        networkRequests.removeValue(forKey: url)
        if let imageId = item.thumbnailImageId(index: 0) {
            item.cachedThumbnailImages[imageId] = image
        }
        if let index = items?.firstIndex(of: item) {
            items?[index] = item
        }
        if let index = displayItems?.firstIndex(of: item) {
            displayItems?[index] = item
        }

        if needsReload && indexpathMap[indexPath] == url {
            post(state: .thumbnailFetched(indexPath))
        }
    }
    
    func fetchItemThumbnail(_ item: Item, _ indexPath: IndexPath, needsReload: Bool = true) {
        let url = item.imageThumbnailUrls[0];
        if let networkService = networkRequests[url] {
            networkService.imageFetchCompletion = { [weak self] image, error in
                guard let strongSelf = self else { return }
                strongSelf.thumbnailFetched(
                    item: item,
                    indexPath,
                    url: url,
                    image: image,
                    error: error,
                    needsReload: needsReload
                )
            }
            return
        }
        let networkService = NetworkService()
        networkRequests[url] = networkService
        let imageId = item.thumbnailImageId(index: 0) ?? ""
        networkService.fetchImage(id:imageId, url: url) { [weak self] image, error in
            guard let strongSelf = self else { return }
            strongSelf.thumbnailFetched(
                item: item,
                indexPath,
                url: url,
                image: image,
                error: error,
                needsReload: needsReload
            )
        }
    }
    
    func filter(text: String?) {
        guard let text = text, text.count > 0 else {
            self.displayItems = self.items
            post(state: .itemsFetched)
            return
        }
        self.displayItems = self.items?.filter { $0.name.lowercased().hasPrefix(text.lowercased())  }
        post(state: .itemsFetched)
    }
    
    func clickedOnItem(at index: Int) {
        guard let item = self.displayItems?[index],
              let navigationController = homeScreenViewController?.navigationController else {
            return
        }
        let itemsDetailNavigator = ItemDetailsViewNavigator(navController: navigationController, item: item)
        itemsDetailNavigator.start()
    }
}
