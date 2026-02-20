import SwiftUI
import PhotosUI
import UIKit

struct PersonalInfoView: View {
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language : String?

    @State var isShowGuideDialog = false
    @State var isShowTermsAndConditionDialog = false
    @State var isShowDeleteAccountDialog = false
    @State var isUseBiometricLoginDialog = false
    
    @State var selectedProfilePhotoItem: PhotosPickerItem?
    @State var profileImage: UIImage?
    @State var scrollbarFlash: Int = 0
    
    @Binding var state : LoginView.PageState
    
    @Binding var tabViewSelection: Int
    
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
                            PhotosPicker(selection: $selectedProfilePhotoItem, matching: .images) {
                                Group {
                                    if let image = profileImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        Image("empty_profile_icon_2")
                                            .resizable().scaledToFit()
                                            .frame(width: 80)
                                    }
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    Image(systemName: "camera.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color("toolbarBackground"))
                                        .background(Circle().fill(.white))
                                }
                            }
                            .onChange(of: selectedProfilePhotoItem) { _, newItem in
                                Task { @MainActor in
                                    guard let newItem else { return }
                                    if let data = try? await newItem.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        let resized = uiImage.resized(to: CGSize(width: 160, height: 160))
                                        if let jpegData = resized.jpegData(compressionQuality: 0.8) {
                                            try? jpegData.write(to: preferenceUtil.profilePhotoURL)
                                            preferenceUtil.hasProfilePhoto = true
                                            profileImage = resized
                                        }
                                    }
                                }
                            }
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                            (tongueScan_iOSApp.loginModel?.username ?? "").localizedText(language: language)
                                .font(.headline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                            Button(action: {
                                tabViewSelection = 0
                            }){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .foregroundStyle(.white)
                                        .shadow(color: Color("light_grey"), radius: 1.5, x: 0, y: 1)
                                    HStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.subheadline)
                                            .foregroundColor(Color("toolbarBackground"))
                                        "go_to_take_photo".localizedText(language: language)
                                            .font(.subheadline)
                                            .foregroundColor(Color("toolbarBackground"))
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding([.top, .bottom], 15)
                                }
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 30))
                            .buttonStyle(ClickScaleDown())

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
                                    "privacyPolicy".localizedText(language: language)
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity)
                                        .padding([.top, .bottom], 15)
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
                                    "guideTitle".localizedText(language: language)
                                        .font(.subheadline)
                                        .foregroundColor(Color("text"))
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity)
                                        .padding([.top, .bottom], 15)
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
                                preferenceUtil.hasProfilePhoto = false
                                profileImage = nil
                                try? FileManager.default.removeItem(at: preferenceUtil.profilePhotoURL)
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
            if profileImage == nil,
               FileManager.default.fileExists(atPath: preferenceUtil.profilePhotoURL.path),
               let data = try? Data(contentsOf: preferenceUtil.profilePhotoURL),
               let image = UIImage(data: data) {
                profileImage = image
            }
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

private extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

