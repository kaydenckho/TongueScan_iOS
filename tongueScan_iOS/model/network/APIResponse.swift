//
//  APIResponse.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 24/6/2024.
//

import Foundation

struct APIResponse<T:Codable> :Codable{
    var code: Int?
    var message: String?
    var data: T?
    
}


