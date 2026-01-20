//
//  ProductModel.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 21/10/2024.
//

import Foundation

struct ProductModel:Codable, Hashable{
    var shopify_id: String?
    var name: String?
    var price: Double?
    var img_link: String?
    var efficacy: String?
    var introduction: String?
    var category: String?
    var type: String?
    var merchant: String?
    var ingredient: String?
    var tutorial: String?
    var jump_link: String?
}
