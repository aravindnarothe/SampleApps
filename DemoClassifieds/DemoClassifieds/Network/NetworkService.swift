//
//  NetworkManager.swift
//  DemoClassifieds
//
//  Created by Aravind on 09/12/2021.
//

import UIKit
import ImageCache

enum NetworkError: Error {
    case serviceBusy
    case invalidInput
    case serverError(Error)
    case parseError
}

@objcMembers
@objc final class NetworkService: NSObject {
    
    typealias ItemsFetchCompletion = ([Item]?, NetworkError?) -> Void
    typealias ImageFetchCompletion = (UIImage?, NetworkError?) -> Void
    typealias ImageFetchObjCompletion = (UIImage?, Error?) -> Void

    typealias JSONDictionary = [String: Any]

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    lazy var imageCache: ImageCache = { return ImageCache.sharedInstance }()
    var imageFetchCompletion: ImageFetchCompletion?

    private func doneFetching(item: [Item]?, error: NetworkError?, completion: ItemsFetchCompletion?) {
        DispatchQueue.main.async {
            completion?(item, error)
        }
    }
    
    private func parseData(data: Data) -> JSONDictionary?  {
        return try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    }

    func fetchItems(url: String, completion: ItemsFetchCompletion?) {
        guard dataTask == nil else {
            doneFetching(item: nil, error: NetworkError.serviceBusy, completion: completion)
            return
        }
        guard let resourceUrl = URL(string: url) else {
            doneFetching(item: nil, error: NetworkError.invalidInput, completion: completion)
            return
        }
        dataTask = defaultSession.dataTask(with: resourceUrl) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }
            defer { strongSelf.dataTask?.cancel() }
            guard error == nil, let data = data else {
                strongSelf.doneFetching(item: nil, error: NetworkError.serverError(error!), completion: completion)
                return
            }
            guard let jsonData = strongSelf.parseData(data: data),
                  let items = jsonData["results"] as? [JSONDictionary] else {
                strongSelf.doneFetching(item: nil, error: NetworkError.parseError, completion: completion)
                return
            }
            var parsedItemsArray = [Item]()
            for item in items {
                guard let parsedItem = Item(item: item)  else {
                    continue
                }
                parsedItemsArray.append(parsedItem)
            }
            strongSelf.doneFetching(item: parsedItemsArray, error: nil, completion: completion)
        }
        dataTask?.resume()
    }
    
    
    private func doneFetching(id: String, image: UIImage?, saveToCache:Bool = true, error: NetworkError?) {
        if (image != nil) && saveToCache == true {
            print("cache test: saving to cache \(id)")
            imageCache.set(image: image!, imageId: id)
        }
        DispatchQueue.main.async { [weak self] in
            self?.imageFetchCompletion?(image, error)
        }
    }
    
    @objc func fetchImageData(id: String, url: String, completion: ImageFetchObjCompletion?) {
        fetchImage(id: id, url: url) { image, error in
            DispatchQueue.main.async {
                completion?(image, error as NSError?)
            }
        }
    }

    func fetchImage(id: String, url: String, completion: ImageFetchCompletion?) {
        imageFetchCompletion = completion
        if let image = imageCache.getImage(id: id) {
            print("cache test: fetching from cache \(id)")
            doneFetching(id: id, image: image, saveToCache: false, error: nil)
            return
        }
        guard dataTask == nil else {
            doneFetching(id: id, image: nil, error: NetworkError.serviceBusy)
            return
        }
        guard let resourceUrl = URL(string: url) else {
            doneFetching(id: id, image: nil, error: NetworkError.invalidInput)
            return
        }
        
        dataTask = defaultSession.dataTask(with: resourceUrl) { [weak self] data, response, error in
            guard let strongSelf = self else {
                return
            }
            defer { strongSelf.dataTask?.cancel() }
            guard error == nil, let data = data else {
                strongSelf.doneFetching(id: id, image: nil, error: NetworkError.serverError(error!))
                return
            }
            guard let image = UIImage(data: data) else {
                strongSelf.doneFetching(id: id, image: nil, error: NetworkError.parseError)
                return
            }
            strongSelf.doneFetching(id: id, image: image, error: nil)
        }
        dataTask?.resume()
    }
}
