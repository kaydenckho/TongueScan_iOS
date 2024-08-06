//
//  ContentView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/8.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @State var isShowTabView = true
    
    @State var isAutoCameraView = false
    @State var isManualCameraView = false
    @State var isLoading = false
    
    @State var language : String?
    
    @State var selection = 0
    
    @State var loginPageState : LoginView.PageState = .Login
    
    var body: some View {
        if (isAutoCameraView){
            CameraView(isPageActive: $isAutoCameraView, language: $language, mode: .Auto)
                .onAppear(){
                    isLoading = false
                    language = preferenceUtil.language
                }
        } else if (isManualCameraView){
            CameraView(isPageActive: $isManualCameraView, language: $language, mode: .Manual)
                .onAppear(){
                    isLoading = false
                    language = preferenceUtil.language
                }
        } else{
            ZStack{
                TabView (selection: $selection){
                    HomeView(language: $language, isAutoCameraView: $isAutoCameraView, isManualCameraView: $isManualCameraView, isLoading: $isLoading, tabViewSelection: $selection)
                       .tabItem {
                           selection == 0 ? Image("home_icon_selected"): Image("home_icon")
                           "home".localizedText(language: language)
                       }.tag(0)
//                    ResultView(isPageActive: $a, language: $language, result: model)
//                       .tabItem {
//                           selection == 1 ? Image("course_icon_selected"): Image("course_icon")
//                           Text("course".localizedString(language: language))
//                       }.tag(1)
//                    WebView(url: Constant.I_HEALS)
//                       .tabItem {
//                           selection == 1 ? Image("course_icon_selected"): Image("course_icon")
//                           Text("course".localized(language: language))
//                       }.tag(1)
//                    WebView(url: Constant.I_HEALS)
//                       .tabItem {
//                           selection == 2 ? Image("health_test_icon_selected"): Image("health_test_icon")
//                           Text("healthTest".localized(language: language))
//                       }.tag(2)
//                    WebView(url: Constant.I_HEALS)
//                        .tabItem {
//                            selection == 3 ? Image("health_mall_icon_selected"): Image("health_mall_icon")
//                            Text("healthMall".localized(language: language))
//                        }.tag(3)
                    LoginView(language: $language, isLoading: $isLoading, tabViewSelection: $selection, state: $loginPageState)
                            .tabItem {
                                selection == 4 ? Image("personal_setting_icon_selected"): Image("personal_setting_icon")
                                "personalSetting".localizedText(language: language)
                            }.tag(4)
                }
                LoadingView(text: "loading".localizedString(language: language)).opacity(isLoading ? 1 : 0)
            }
            .onAppear(){
                if (preferenceUtil.isRememberLogin ?? false){
                    loginPageState = .LoggedIn
                    tongueRecognition_iOSApp.loginModel = LoginModel(token: preferenceUtil.token, username: preferenceUtil.username)
                } else{
                    loginPageState = .Login
                }
                language = preferenceUtil.language
            }
          
        }
       

    }
}

