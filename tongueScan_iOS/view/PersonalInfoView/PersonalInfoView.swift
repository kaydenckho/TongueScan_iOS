import SwiftUI

struct PersonalInfoView: View {
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language : String?

    @State var isShowGuideDialog = false
    @State var isShowTermsAndConditionDialog = false
    @State var isShowDeleteAccountDialog = false
    @State var isUseBiometricLoginDialog = false
    
    @State var scrollbarFlash: Int = 0
    
    @Binding var state : LoginView.PageState
    
    @StateObject private var vm = PersonalInfoViewVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader{ geometry in
                    Image("index_topbar_bg")
                        .resizable()
                        .ignoresSafeArea()
                        .frame(height: geometry.size.height*0.35)
                    HStack{
                        Spacer()
                        VStack(){
                            Image("index_topbar_icon")
                                .resizable().scaledToFit()
                                .frame(width: 100)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            Image("empty_profile_icon_2")
                                .resizable().scaledToFit()
                                .frame(width: 80)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            (tongueScan_iOSApp.loginModel?.username ?? "").localizedText(language: language)
                                .font(.headline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                            Button(action: {
                                withAnimation(.linear(duration: 2.0)){
                                    isShowTermsAndConditionDialog = true
                                }completion: {
                                    scrollbarFlash += 1
                                }
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundStyle(.white)
                                        .shadow(color: Color("light_grey"), radius: 1.5, x: 0, y: 1)
                                    HStack{
                                        "termsAndConditions".localizedText(language: language)
                                            .font(.subheadline)
                                            .foregroundColor(Color("text"))
                                                .padding([.leading, .trailing], 10)
                                                .padding([.top, .bottom], 15)
                                                .lineLimit(1)
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                        Spacer()
                                    }
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                            .buttonStyle(ClickScaleDown())
                            
                            Button(action: {
                                withAnimation(.linear(duration: 2.0)){
                                    isShowGuideDialog = true
                                }completion: {
                                    scrollbarFlash += 1
                                }
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundStyle(.white)
                                        .shadow(color: Color("light_grey"), radius: 1.5, x: 0, y: 1)
                                    HStack{
                                        "guideTitle".localizedText(language: language)
                                            .font(.subheadline)
                                            .foregroundColor(Color("text"))
                                                .padding([.leading, .trailing], 10)
                                                .padding([.top, .bottom], 15)
                                                .lineLimit(1)
                                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                        Spacer()
                                    }
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                            .buttonStyle(ClickScaleDown())
                            
                            Button(action: {
                                tongueScan_iOSApp.loginModel = nil
                                preferenceUtil.token = nil
                                preferenceUtil.username = nil
                                preferenceUtil.isAgreedTerms = false
                                preferenceUtil.isUseBiometricLogin = false
                                preferenceUtil.isRememberLogin = false
                                state = .Login
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundStyle(.white)
                                        .shadow(color: Color("light_grey"), radius: 1.5, x: 0, y: 1)
                                    HStack{
                                        Spacer()
                                        Image("logout_icon")
                                            .resizable().scaledToFit()
                                            .frame(width: 25)
                                        "logout".localizedText(language: language)
                                            .font(.subheadline)
                                            .foregroundColor(Color("text"))
                                                .padding([.top, .bottom], 15)
                                                .lineLimit(1)
                                        Spacer()
                                    }
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                            .buttonStyle(ClickScaleDown())
                        
                            Button(action: {
                                isShowDeleteAccountDialog = true
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundStyle(.white)
                                        .shadow(color: Color("light_grey"), radius: 1.5, x: 0, y: 1)
                                    HStack{
                                        Spacer()
                                        Image(systemName: "trash.slash")
                                            .resizable().scaledToFit()
                                            .frame(width: 25)
                                            .foregroundColor(Color("indicator_grey"))
                                        "deleteAccount".localizedText(language: language)
                                            .font(.subheadline)
                                            .foregroundColor(Color("text"))
                                                .padding([.top, .bottom], 15)
                                                .lineLimit(1)
                                        Spacer()
                                    }
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                            .buttonStyle(ClickScaleDown())
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .alert("deleteAccountDescription".localizedString(language: language), isPresented: $isShowDeleteAccountDialog){
                    Button("confirm".localizedString(language: language), role: .cancel) { isShowDeleteAccountDialog = false }
                }
                .alert(isPresented: $isUseBiometricLoginDialog) {
                    Alert(
                        title: "hint".localizedText(language: language),
                        message: "isUseBiometricLogin".localizedText(language: language),
                        primaryButton: .default(
                            "enable".localizedText(language: language),
                            action: { preferenceUtil.isUseBiometricLogin = true }
                        ),
                        secondaryButton: .destructive(
                            "dontAskAgain".localizedText(language: language),
                            action: { preferenceUtil.isUseBiometricLogin = true }
                        )
                    )
                }
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
            }
        }
        .onAppear(){
            if (!(preferenceUtil.isUseBiometricLogin ?? false)){
                isUseBiometricLoginDialog = true
            }
            if let token = preferenceUtil.token{
                Task{
                    await vm.userInfo(token:token,onSuccess:{
                        tongueScan_iOSApp.loginModel = LoginModel(token: vm.userInfoModel?.data?.token, username: vm.userInfoModel?.data?.username)
                        preferenceUtil.token = vm.userInfoModel?.data?.token
                        preferenceUtil.username = vm.userInfoModel?.data?.username
                    }, onFailure:{})
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeOut(duration: 0.16))
    }

}

