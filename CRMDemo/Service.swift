//
//  Service.swift
//  CRMDemo
//
//  Created by Tariq Najib on 06/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
import UIKit
import CustomRestManager
class Service {
    static let shared = Service()
    var imagedata: UIImage!
    init() {}
    let mainURL = URL(string: "http://pastebin.com/raw/wgkJgazE")
    private let apiCaller = CustomRestManager.shared
    func downloadImages(toURL: URL, completion: @escaping (_ data: UIImage?) -> Void) {
        if let cachedImg = self.apiCaller.ctCache.memoryCache.getCachedObjForKey(cacheKey: NSString(string: toURL.absoluteString)) {
            self.imagedata = UIImage(data: cachedImg)
            print("getting from cache")
            completion(self.imagedata)
        } else {
            print("getting from url")
            apiCaller.makeRequest(toURL: toURL, withHttpMethod: CustomRestManager.HttpsMethods.get) { [weak self] (result) in
                DispatchQueue.main.async {
                    if result.response?.httpStatusCode == 200 {
                        if let data = result.data {
                            self?.imagedata = UIImage(data: data)
                            completion(self?.imagedata)
                        } else {
                            print("Error fetching images", result.error!)
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func loadPins(completion: @escaping ([Pins]) -> Void) {
        let getMethod = CustomRestManager.HttpsMethods.get
        
        apiCaller.makeRequest(toURL: mainURL!, withHttpMethod: getMethod, completion: { (results) in
            print("getting data...")
            DispatchQueue.main.async {
                do {
                    if let data = results.data {
                        let decoder = JSONDecoder()
                        let decodedPins = try decoder.decode([Pins].self, from: data)
                        completion(decodedPins)
                    }
                } catch {
                    print(error)
                }
            }
        })
    }
    func loadMorePins(page: Int, completion: @escaping ([Pins]) -> Void) {
        let getMethod = CustomRestManager.HttpsMethods.get
        apiCaller.urlQueryParameters.add(value: String(page), forKey: "page")
        apiCaller.makeRequest(toURL: mainURL!, withHttpMethod: getMethod, completion: { (results) in
            print("getting data...")
            DispatchQueue.main.async {
                do {
                    if let data = results.data {
                        let decoder = JSONDecoder()
                        let decodedPins = try decoder.decode([Pins].self, from: data)
                        completion(decodedPins)
                    }
                } catch {
                    print(error)
                }
            }
        })
    }
}
