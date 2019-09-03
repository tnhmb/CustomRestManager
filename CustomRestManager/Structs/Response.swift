//
//  Response.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 31/08/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
public struct Response {
    public var response: URLResponse?
    public var httpStatusCode: Int = 0
    public var headers = APIEntity()
    
    init(urlResponse response: URLResponse?) {
        if let response = response {
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        } else { return }
        
    }
}
