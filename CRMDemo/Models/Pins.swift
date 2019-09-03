//
//  Pins.swift
//  CRMDemo
//
//  Created by Tariq Najib on 02/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
struct Pins: Decodable {
    var id: String?
    var createdAt: String?
    var width: Int?
    var height: Int?
    var color: String?
    var likes: Int?
    var isLikedByUser: Bool?
    var user: User?
    var imageUrls: ImageUrls?
    //var categories: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case color
        case likes
        case isLikedByUser = "liked_by_user"
        //case user
        case imageUrls = "urls"
        //case categories
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        color = try values.decode(String.self, forKey: .color)
        //user = try values.decode(User.self, forKey: .user)
        imageUrls = try values.decode(ImageUrls.self, forKey: .imageUrls)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        likes = try values.decode(Int.self, forKey: .likes)
        isLikedByUser = try values.decode(Bool.self, forKey: .isLikedByUser)
        //categories = try values.decode([Category].self, forKey: .categories)
    }
}
