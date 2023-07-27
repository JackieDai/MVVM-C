//
//  User.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation
struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
}
