//
//  GalleryStore.swift
//  LRConnectionExample(Swift)
//
//  Created by Ruan Lingqi on 26/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit
import LRConnection

fileprivate let EndPoint = "https://api.flickr.com/services/rest"
fileprivate let APIKey = "a6d819499131071f158fd740860a5a88"
fileprivate let FetchRecentsMethod = "flickr.photos.getRecent"

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum FlickrError: Error {
    case invalidJSONData
    case imageCreationError
}

class GalleryStore {

    static let shared = GalleryStore()
    
    private var recentItems = [GalleryItem]()
    private var imageCache = [String: UIImage]()
    
    private init() {}
    
    
    // MARK: - Networking
    
    func fetchRecentPhotos(success: @escaping ([GalleryItem]) -> Void, failure: @escaping (Error) -> Void) {
        if recentItems.count > 0 {
            DispatchQueue.main.async {
                success(self.recentItems)
            }
            return
        }
        let params = [
            "api_key": APIKey,
            "format": "json",
            "nojsoncallback": "1",
            "extras": "url_s",
            "method": FetchRecentsMethod
        ]
        let manager = LRConnectionManager.shared()
        manager.request(forUrl: EndPoint, method: .GET, params: params, progress: nil, success: { (data) in
            do {
                try self.parseItems(&self.recentItems, jsonData: data)
                success(self.recentItems)
            } catch let error {
                failure(error)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    func fetchImage(for galleryItem: GalleryItem, completion: @escaping (ImageResult) -> Void) {
        let imageKey = galleryItem.imageUrl
        if let image = imageCache[imageKey] {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            return
        }
        let manager = LRConnectionManager.shared()
        manager.request(forUrl: imageKey, method: .GET, params: nil, progress: nil, success: { (data) in
            if let image = UIImage(data: data) {
                self.imageCache[imageKey] = image
                completion(.success(image))
            } else {
                completion(.failure(FlickrError.imageCreationError))
            }
        }, failure: { (error) in
            completion(.failure(error))
        })
    }
    
    
    // MARK: - Parse JSON Results
    
    private func parseItems(_ items: inout [GalleryItem], jsonData: Data) throws {
        items.removeAll()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard
                let jsonBody = json as? [String: Any],
                let jsonObject = jsonBody["photos"] as? [String: Any],
                let jsonArray = jsonObject["photo"] as? [[String: Any]] else {
                    throw FlickrError.invalidJSONData
            }
            for jsonDict in jsonArray {
                if let item = parseItemFrom(jsonDict: jsonDict) {
                    items.append(item)
                }
            }
        } catch let error {
            throw error
        }
    }
    
    private func parseItemFrom(jsonDict: [String: Any]) -> GalleryItem? {
        guard
            let itemID = jsonDict["id"] as? String,
            let caption = jsonDict["title"] as? String,
            let owner = jsonDict["owner"] as? String,
            let imageUrl = jsonDict["url_s"] as? String else {
                return nil
        }
        return GalleryItem(itemID: itemID, caption: caption, owner: owner, imageUrl: imageUrl)
    }
}
