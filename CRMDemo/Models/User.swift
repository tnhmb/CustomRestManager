//
//  User.swift
//  CRMDemo
//
//  Created by Tariq Najib on 02/09/2019.
//  Copyright © 2019 Tariq Najib. All rights reserved.
//

import Foundation
struct User: Codable {
    let id: String?
    let userName: String?
    let name: String?
    //let profileImage: ImageUrls?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "username"
        case name
        //case profileImage = "profile_image"
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        userName = try values.decode(String.self, forKey: .userName)
        name = try values.decode(String.self, forKey: .name)
        //profileImage = try values.decode(ImageUrls.self, forKey: .profileImage)
    }
}
