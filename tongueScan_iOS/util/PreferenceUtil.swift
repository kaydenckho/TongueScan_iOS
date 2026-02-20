//
//  PreferenceUtil.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 15/12/2023.
//

import SwiftUI

@Observable
class PreferenceUtil{
    
    let LANGUAGE = "LANGUAGE"
    let THEME = "THEME"
    let IS_AGREED_TERMS = "IS_AGREED_TERMS"
    let IS_REMEMBER_LOGIN = "IS_REMEMBER_LOGIN"
    let IS_USE_BIOMETRIC_LOGIN = "IS_USE_BIOMETRIC_LOGIN"
    let USERNAME = "USERNAME"
    let TOKEN = "TOKEN"
    let HAS_PROFILE_PHOTO = "HAS_PROFILE_PHOTO"
    
    static let profilePhotoFilename = "profile_photo.jpg"
    
    init() {
        language = UserDefaults.standard.string(forKey: LANGUAGE)
        theme = UserDefaults.standard.object(forKey: THEME) as? ColorScheme
        isAgreedTerms = UserDefaults.standard.bool(forKey: IS_AGREED_TERMS)
        isRememberLogin = UserDefaults.standard.bool(forKey: IS_REMEMBER_LOGIN)
        isUseBiometricLogin = UserDefaults.standard.bool(forKey: IS_USE_BIOMETRIC_LOGIN)
        username = UserDefaults.standard.string(forKey: USERNAME)
        token = UserDefaults.standard.string(forKey: TOKEN)
        hasProfilePhoto = UserDefaults.standard.bool(forKey: HAS_PROFILE_PHOTO)
    }

    
    var language: String? = nil{
            didSet {
                guard oldValue != self.language else { return }
                UserDefaults.standard.set(self.language, forKey: LANGUAGE)
            }
        }
    
    var theme: ColorScheme? = nil{
            didSet {
                guard oldValue != self.theme else { return }
                UserDefaults.standard.set(self.theme, forKey: THEME)
            }
        }
    
    var isAgreedTerms: Bool? = nil{
            didSet {
                guard oldValue != self.isAgreedTerms else { return }
                UserDefaults.standard.set(self.isAgreedTerms, forKey: IS_AGREED_TERMS)
            }
        }
    
    var isRememberLogin: Bool? = nil{
            didSet {
                guard oldValue != self.isRememberLogin else { return }
                UserDefaults.standard.set(self.isRememberLogin, forKey: IS_REMEMBER_LOGIN)
            }
        }
    
    var isUseBiometricLogin: Bool? = nil{
            didSet {
                guard oldValue != self.isUseBiometricLogin else { return }
                UserDefaults.standard.set(self.isUseBiometricLogin, forKey: IS_USE_BIOMETRIC_LOGIN)
            }
        }
    
    var username: String? = nil{
            didSet {
                guard oldValue != self.username else { return }
                UserDefaults.standard.set(self.username, forKey: USERNAME)
            }
        }
    
    var token: String? = nil{
            didSet {
                guard oldValue != self.token else { return }
                UserDefaults.standard.set(self.token, forKey: TOKEN)
            }
        }
    
    var hasProfilePhoto: Bool = false {
        didSet {
            guard oldValue != self.hasProfilePhoto else { return }
            UserDefaults.standard.set(self.hasProfilePhoto, forKey: HAS_PROFILE_PHOTO)
        }
    }
    
    var profilePhotoURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(PreferenceUtil.profilePhotoFilename)
    }
}
