//
//  LoginModel.swift
//  tongueRecognition_iOS
//
//  Created by kayd3nckh on 24/6/2024.
//

import Foundation

struct LoginModel:Codable, Equatable{
    var message: String?
    var token: String?
    var username: String?
    
    public static func !=(lhs: LoginModel, rhs: LoginModel) -> Bool{
        return
            lhs.message != rhs.message &&
            lhs.token != rhs.token &&
            lhs.username == rhs.username
    }
}
