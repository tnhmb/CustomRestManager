//
//  APIEntity.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 31/08/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
public struct APIEntity {
    private var values: [String : String] = [:]
    
    public mutating func add(value: String, forKey key: String) {
        values[key] = value
    }
    public mutating func addAny<T: LosslessStringConvertible>(value: T, forKey key: String) {
        values[key] = String(value)
    }
    public func value(forKey key: String) -> String? {
        return values[key]
    }
    
    public func allValues() -> [String: String] {
        return values
    }
    
    public func totalItems() -> Int {
        return values.count
    }
    
}

