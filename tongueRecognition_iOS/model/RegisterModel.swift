//
//  RegisterModel.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 25/6/2024.
//

import Foundation

struct RegisterModel:Codable{
    var message: String?
    var token: String?
    var username: String?
    var email: String?
    var session_id: String?
    var code: String?
}
