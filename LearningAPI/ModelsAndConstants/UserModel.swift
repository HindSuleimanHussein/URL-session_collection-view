//
//  UserModel.swift
//  LearningAPI
//
//  Created by Foothill on 15/11/2023.
//

import Foundation

struct UserModel: Codable {
    let name: String?
    let bio: String?
    let avatar_url: String?
    let followers: Int?
    
}
