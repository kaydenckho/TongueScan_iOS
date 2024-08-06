//
//  HomeView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/9.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language : String?
    
    @StateObject private var vm = HomeVM()
    
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @Binding var isAutoCameraView :Bool
    @Binding var isManualCameraView :Bool
    
    @Binding var isLoading:Bool
    
    @State var isShowGuideDialog = false
    @State var isShowTermsAndConditionDialog = false
    @State var isShowTermsAndConditionDialogWithDisagree = false
    
    @State var isShowLoginDialog = false
    
    @State var mode: CameraView.Mode = .Auto
    
    @State var scrollbarFlash: Int = 0
    
    @Binding var tabViewSelection:Int
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                GeometryReader{ geometry in
                    VStack(alignment:.leading, spacing: 0){
                        ZStack{
                            Path{ path in
                                path.move(to: CGPoint(x:0, y: 0))
                                path.addLine(to: CGPoint(x:0, y: geometry.size.height/2-50))
                                path.addQuadCurve(to: CGPoint(x:geometry.size.width, y: geometry.size.height/2-50), control: CGPoint(x:geometry.size.width/2, y: geometry.size.height/2+50))
                                path.addLine(to: CGPoint(x:geometry.size.width, y: 0))
                            }.fill(Color(.green1))
                            Image("health_test_bg_camera")
                                .resizable().scaledToFit()
                                .frame(width: 250, height: 250)
                        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: .infinity,
                                minHeight:0, maxHeight: geometry.size.height/2)
                        .padding([.bottom], 50)
                        
                        HStack {
                            Spacer()
                            HStack (alignment: .center){
                                Button(action: {
                                    preferenceUtil.language = "zh-Hans"
                                    language = "zh-Hans"
                                }){
                                    Text("简").foregroundColor(Color("toolbarBackground"))
                                        .fontWeight(.semibold)
                                        .frame(alignment: .center)
                                }
                                Text("|").foregroundColor(Color("toolbarBackground")).offset(y:-1)
                                    .fontWeight(.medium)
                                Button(action: {
                                    preferenceUtil.language = "zh-HK"
                                    language = "zh-HK"
                                }){
                                    Text("繁").foregroundColor(Color("toolbarBackground"))
                                        .fontWeight(.semibold)
                                        .frame(alignment: .center)
                                }
                                Text("|").foregroundColor(Color("toolbarBackground")).offset(y:-1)
                                    .fontWeight(.medium)
                                Button(action: {
                                    preferenceUtil.language = "en"
                                    language = "en"
                                }){
                                    Text("ENG").foregroundColor(Color("toolbarBackground"))
                                        .fontWeight(.medium)
                                }
                            }
                            Spacer()
                        }
                        .padding([.bottom], 30)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                Task{
                                    mode = .Auto
                                    if (tongueRecognition_iOSApp.loginModel == nil){
                                        isShowLoginDialog = true
                                    } else{
                                        if (preferenceUtil.isAgreedTerms ?? false){
                                            isAutoCameraView = true
                                        } else{
                                            isShowTermsAndConditionDialogWithDisagree = true
                                        }
                                    }
                                }
                            }){
                                Button1View(text: "auto_mode".localizedString(language: language), width: 120, color: Color("toolbarBackground"), topLeading:10, bottomLeading:10, topTrailing:10, bottomTrailing:10, verticalPadding:15, textSize: Font.headline, textColor:.white)
                            }
                            .padding([.leading, .trailing], 5)
                            .buttonStyle(ClickScaleDown())
                            Button(action: {
                                Task{
                                    mode = .Manual
                                    if (tongueRecognition_iOSApp.loginModel == nil){
                                        isShowLoginDialog = true
                                    } else{
                                        if (preferenceUtil.isAgreedTerms ?? false){
                                            isManualCameraView = true
                                        } else{
                                            isShowTermsAndConditionDialogWithDisagree = true
                                        }
                                    }
                                }
                            }){
                                Button1View(text: "manual_mode".localizedString(language: language), width: 120, color: Color("button_green2"), topLeading:10, bottomLeading:10, topTrailing:10, bottomTrailing:10,verticalPadding:15, textSize: Font.headline, textColor:.white)
                            }
                            .padding([.leading, .trailing], 5)
                            .buttonStyle(ClickScaleDown())
                            Spacer()
                        }
                        .padding([.bottom], 20)
                        .alert("hint".localizedText(language: language), isPresented: $isShowLoginDialog) {
                            Button("continue_to_test".localizedString(language: language)) {
                                if (preferenceUtil.isAgreedTerms ?? false){
                                    if (mode == .Auto){
                                        isAutoCameraView = true
                                    } else{
                                        isManualCameraView = true
                                    }
                                } else{
                                    isShowTermsAndConditionDialogWithDisagree = true
                                }
                            }
                            Button("go_to_login".localizedString(language: language), role: .destructive) {
                                tabViewSelection = 4
                            }
                            Button("cancel".localizedString(language: language), role: .cancel) {}
                        } message: {
                            "hint_login".localizedText(language: language)
                        }
                        
                        HStack {
                            Spacer()
                            "tongueDemoDescription".localizedText(language: language)
                                .foregroundColor(Color("toolbarBackground"))
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                                .font(.footnote)
                            Spacer()
                        }
                        .padding([.bottom], 20)
                        HStack {
                            Spacer()
                            Button(action: {
                                Task{
                                    withAnimation(.linear(duration: 2.0)){
                                        isShowGuideDialog = true
                                    }completion: {
                                        scrollbarFlash += 1
                                    }
                                }
                            }){
                                VStack{
                                    Image("guide_icon")
                                        .resizable().scaledToFit()
                                        .frame(width: 30, height: 30)
                                    "guideTitle".localizedText(language: language)
                                        .foregroundColor(Color("toolbarBackground"))
                                        .multilineTextAlignment(.center)
                                        .fontWeight(.bold)
                                        .font(.footnote)
                                }
                            }
                            .buttonStyle(ClickScaleDown())
                            .padding([.leading, .trailing], 15)
                            Divider()
                            Button(action: {
                                Task{
                                    withAnimation(.linear(duration: 2.0)){
                                        isShowTermsAndConditionDialog = true
                                    }completion: {
                                        scrollbarFlash += 1
                                    }
                                }
                            }){
                                VStack{
                                    Image("precautions_icon")
                                        .resizable().scaledToFit()
                                        .frame(width: 30, height: 30)
                                    "termsAndConditions".localizedText(language: language)
                                        .foregroundColor(Color("toolbarBackground"))
                                        .multilineTextAlignment(.center)
                                        .fontWeight(.bold)
                                        .font(.footnote)
                                }
                            }
                            .buttonStyle(ClickScaleDown())
                            .padding([.leading, .trailing], 15)
                            Spacer()
                        }.frame(maxHeight: 100)
                        
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image("index_topbar_icon")
                            .resizable().scaledToFit()
                            .frame(width: 70)
                    }
                    ToolbarItem(placement: .principal) {
                        "appName".localizedText(language: language)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .toolbarTitleDisplayMode(.inline)
                .toolbarBackground(Color("toolbarBackground"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                if (isShowGuideDialog){
                    TextDialog(isActive: $isShowGuideDialog, titleArr: ["guideTitle".localizedString(language: language)],
                               description: "guideDescription".localizedText(language: language),
                               rightButtonText: "guide_agree_btn_text".localizedString(language: language),rightBtnAction:{
                        isShowGuideDialog = false
                    }, trigger: $scrollbarFlash)
                }
                if (isShowTermsAndConditionDialog){
                    TextDialog(isActive: $isShowTermsAndConditionDialog,titleArr: ["termsAndConditions_title".localizedString(language: language)],
                               description: "termsAndConditions_description".localizedText(language: language),
                               rightButtonText: "guide_agree_btn_text".localizedString(language: language), rightBtnAction:{
                        isShowTermsAndConditionDialog = false
                    }, trigger: $scrollbarFlash)
                }
                if (isShowTermsAndConditionDialogWithDisagree){
                    TextDialog(isActive: $isShowTermsAndConditionDialogWithDisagree, titleArr: ["termsAndConditions_title".localizedString(language: language)],
                               description: "termsAndConditions_description".localizedText(language: language),
                               leftButtonText: "termsAndConditions_disagree_btn_text".localizedString(language:language),
                               rightButtonText: "termsAndConditions_agree_btn_text".localizedString(language:language),
                               leftBtnAction:{
                        isShowTermsAndConditionDialogWithDisagree = false
                    },
                               rightBtnAction:{
                        isShowTermsAndConditionDialogWithDisagree = false
                        preferenceUtil.isAgreedTerms = true
                        if (mode == .Auto){
                            isAutoCameraView = true
                        } else{
                            isManualCameraView = true
                        }
                    }, trigger: $scrollbarFlash)
                }
            }
            .alert("upload_failed_msg", isPresented: $vm.uploadFailed){
                Button("confirm", role: .cancel) { vm.uploadFailed = false }
            }
            .animation(.easeOut(duration: 0.16))
        }
    }
    
}
