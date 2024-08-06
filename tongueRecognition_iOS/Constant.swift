//
//  Constant.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/12.
//

import Foundation

struct Constant {
    static let BASE_URL = "https://ecbothk.com/api/"
    // Login & Register
    static let LOGIN = "user/login/username_email"
    static let REGISTER = "user/register/email/verify"
    static let RESET_PASSWORD = "user/forget/password/reset"
    static let OBTAIN_EMAIL_REGISTER_CODE = "user/register/email/code"
    static let OBTAIN_EMAIL_FORGET_PASSWORD_CODE = "user/forget/password/code"
    // Questionnaire
    static let OBTAIN_SURVEY_NAMES = "questionnaire/names"
    static let OBTAIN_SURVEY = "questionnaire/surveys"
    static let SUBMIT_SURVEY = "questionnaire/results"
    static let QUESTIONNAIRE_RESULTS = "questionnaire/results/abs"
    // Tongue Test
    static let TONGUE_RESULT = "tongue/result"
    static let BASE_URL_2 = "http://43.129.194.142:5000/"
    static let TONGUE_EXPLAIN = "tongue_explain"
    static let RESULT_APPOINTMENT = "https://shop.ecbothk.com/products/%E9%A0%90%E7%B4%84%E5%92%A8%E8%A9%A2"
    static let RESULT_QUESTIONNAIRE = "https://ecbothk.com"
 }
