//
//  MemoryCache.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 02/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation

public class MemoryCache: CTCacheProvider {
    
    private let cache = NSCache<NSString, NSData>()
    
    public func setCacheLimit(limitInMB limit: Int) {
        cache.totalCostLimit = limit * 1024 * 1024
    }

    public func getCachedObjForKey(cacheKey: NSString) -> Data? {
        guard let cachedObj = cache.object(forKey: cacheKey) as Data? else { return nil}
        return cachedObj
    }
    
    public func setCacheObjForKey(cacheKey: NSString, value: NSData?) {
        if let cachedObj = value {
            self.cache.setObject(cachedObj, forKey: cacheKey)
        } else {
            self.cache.removeObject(forKey: cacheKey)
        }
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    
}
