//
//  Results.swift
//  CustomRestManager
//
//  Created by Tariq Najib on 31/08/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
public struct Results {
    public var data: Data?
    public var response: Response?
    public var error: Error?
    init(withData data: Data?, response: Response?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(withError error: Error) {
        self.error = error
    }
}
