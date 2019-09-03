//
//  ImageUrls.swift
//  CRMDemo
//
//  Created by Tariq Najib on 02/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
struct ImageUrls: Codable {
    let raw, full, regular, small: String
    let thumb: String
    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        raw = try values.decode(String.self, forKey: .raw)
        full = try values.decode(String.self, forKey: .full)
        regular = try values.decode(String.self, forKey: .regular)
        small = try values.decode(String.self, forKey: .small)
        thumb = try values.decode(String.self, forKey: .thumb)
    }
}
