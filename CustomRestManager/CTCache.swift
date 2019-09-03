//
//  CTCache.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 02/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
public protocol CTCacheProvider {
    func setCacheLimit(limitInMB limit: Int)
    func getCachedObjForKey(cacheKey: NSString) -> Data?
    func setCacheObjForKey(cacheKey: NSString, value: NSData?)
    func clearCache()
}
public class CTCache  {
    public var memoryCache = MemoryCache()
    public static let shared = CTCache()
    public subscript(cacheKey key: String) -> Data? {
        get {
            guard let result = memoryCache.getCachedObjForKey(cacheKey: NSString(string: key)) else { return nil}
            return result
        }
        set {
            let data = newValue as NSData?
            memoryCache.setCacheObjForKey(cacheKey: NSString(string: key), value: data)
        }
    }
    public func setCacheLimit(limitInMB limit: Int){
        memoryCache.setCacheLimit(limitInMB: limit)
    }
    public func clearCache() {
        memoryCache.clearCache()
    }
}
