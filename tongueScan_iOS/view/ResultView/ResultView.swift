//
//  ResultView.swift
//  tongueScan_iOS
//
//  Created by user on 2023/6/13.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.openURL) var openURL
    
    @StateObject private var vm = ResultViewVM()
    
    var onDismiss: () -> Void
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language: String?
    
    let result: UploadImagesResult?
    
    @State var tongueDiabetesDescription = ""
    @State var tongueBodyColorDescription = ""
    @State var tongueCoatingColorDescription = ""
    @State var tongueCoatingThicknessDescription = ""
    @State var otherFindingDescription = ""
    
    @State var healthIndicatorOffsetX  = 0.0
    
    @State var openWebView = false
    @State var url = ""
    @State var isAppointment = false
    
    @State var isShowFullPhoto = false
    
    @State var isShowDiabetesTongueExp = false
//    @State var isShowTongueBodyColorExp = false
//    @State var isShowCoatingColorExp = false
//    @State var isShowCoatingThicknessExp = false
//    @State var isShowOtherFindingExp = false
    
    @State var isLoading: Bool = false
    
    let horizontalPadding = 20.0
    
    @State var scrollbarFlash: Int = 0
    
    @State var isShowLoginDialog = false
    
    @Binding var tabViewSelection:Int
    
    var body: some View {
        GeometryReader { geometry in
            if (openWebView){
                NavigationStack{
                    ZStack{
                        WebView(url:url)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action:{
                                openWebView.toggle()
                            }){
                                Image(systemName: "chevron.backward").foregroundColor(.white)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            let title = "gotoWeb"
                            title.localizedText(language: language)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    .navigationBarBackButtonHidden()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color("toolbarBackground"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                }
                .animation(.easeOut(duration: 0.16))
            } else{
                NavigationStack {
                        ZStack{
                            Color("background")
                            ScrollViewReader { value in
                                ScrollView(showsIndicators:false){
                                    VStack() {
                                        Group{
                                            HStack(){
                                                VStack{
                                                    if let image = result?.image{
                                                        Button(action: {
                                                            if (tongueScan_iOSApp.loginModel != nil){
                                                                if (vm.resultImage != nil){
                                                                    isShowFullPhoto.toggle()
                                                                }
                                                            } else{
                                                                isShowLoginDialog.toggle()
                                                            }
                                                        }){
                                                            if let img = vm.resultImage, let uiImage = UIImage(data: img){
                                                                Image(uiImage: uiImage)
                                                                    .resizable()
                                                                    .cornerRadius(25)
                                                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                                                                    .frame(width: 250, height: 275)
                                                            } else{
                                                                ProgressView(NSLocalizedString("loading", comment: ""))
                                                                    .scaleEffect(1)
                                                                    .tint(Color("toolbarBackground"))
                                                                    .foregroundColor(Color("toolbarBackground"))
                                                                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                                                                    .frame(width: 250, height: 275)
                                                            }
                                                        }
                                                        "result_click_to_see_full_image".localizedText(language: language)
                                                            .foregroundColor(Color("result_grey"))
                                                            .fontWeight(.bold)
                                                            .font(.subheadline)
                                                    }
                                                    
                                                }
                                                VStack{
                                                    Button(action: {
                                                        if (!vm.isSavedPhoto){
                                                            vm.saveImage()
                                                        }
                                                        vm.showSavedPhotoAlert.toggle()
                                                    }){
                                                        DialogButtonView(text: "save_tongue".localizedString(language: language), width: 100, backgroundColor: Color("transparent"), borderColor: Color("toolbarBackground"), textColor: Color("toolbarBackground"), isTextBold: true,
                                                                         fontSize: .footnote, cornerRadius: 20)
                                                    }
                                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                                    .buttonStyle(ClickScaleDown())
                                                    if let imageData = vm.resultImage, let shareImage = UIImage(data: imageData){
                                                        let title = "share_tongue".localizedString(language: language)
                                                        let item = Image(uiImage: shareImage)
                                                        ShareLink(item: item, preview: SharePreview(title, image: item)){
                                                            DialogButtonView(text: "share_tongue".localizedString(language: language), width: 100, backgroundColor: Color("transparent"), borderColor: Color("toolbarBackground"), textColor: Color("toolbarBackground"), isTextBold: true,
                                                                             fontSize: .footnote, cornerRadius: 20
                                                            )
                                                        }
                                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                                        .buttonStyle(ClickScaleDown())
                                                    }
                                                    Button(action: onDismiss) {
                                                        DialogButtonView(text: "retry".localizedString(language: language), width: 100, backgroundColor: Color("transparent"), borderColor: Color("toolbarBackground"), textColor: Color("toolbarBackground"), isTextBold: true,
                                                                         fontSize: .footnote, cornerRadius: 20)
                                                    }
                                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                                    .buttonStyle(ClickScaleDown())
                                                }
                                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                                            }
                                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                        }
                                        HStack{
                                            let dateString = "result_test_date".localizedString(language: language) + getCurrentDate()
                                            Text(dateString)
                                                .foregroundColor(Color("result_grey"))
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                        HStack{
                                            Text("resultDesc".localizedString(language: language))
                                                .foregroundColor(Color("result_grey"))
                                                .fontWeight(.bold)
                                                .font(.footnote)
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                        HStack{
                                            Spacer()
                                            Button(action:{
                                                if let url = URL(string: Constant.SHOPIFY) {
                                                    openURL(url)
                                                }
                                            }){
                                                DialogButtonView(text: "gotoWeb".localizedString(language: language), width: 100, backgroundColor: Color("transparent"), borderColor: Color("toolbarBackground"), textColor: Color("toolbarBackground"), isTextBold: true,
                                                                 fontSize: .footnote, cornerRadius: 20)
                                            }
                                            .buttonStyle(ClickScaleDown())
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    }
                                    .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarLeading) {
                                            Button(action: onDismiss) {
                                                Image(systemName: "chevron.backward").foregroundColor(.white)
                                            }
                                        }
                                        ToolbarItem(placement: .principal) {
                                            "result_title".localizedText(language: language)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .navigationBarTitleDisplayMode(.inline)
                                    .toolbarBackground(Color("toolbarBackground"), for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)
                                }
                            }
                            if isShowFullPhoto, let resultImage = vm.resultImage {
                                ImageDialog(isActive: $isShowFullPhoto, image: resultImage)
                            }
                            if (isShowDiabetesTongueExp){
                                TextDialog(isActive: $isShowDiabetesTongueExp,
                                           titleArr: "diabetesTongueTitle".localizedString(language: language).replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (tongueDiabetesDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
//                            if (isShowTongueBodyColorExp){
//                                TextDialog(isActive: $isShowTongueBodyColorExp,
//                                           titleArr: result?.result?.tontue_color_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
//                                           description: (tongueBodyColorDescription).localizedText(language: language)
//                                           , trigger: $scrollbarFlash
//                                )
//                            }
//                            if (isShowCoatingColorExp){
//                                TextDialog(isActive: $isShowCoatingColorExp,
//                                           titleArr: result?.result?.coating_color_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
//                                           description: (tongueCoatingColorDescription).localizedText(language: language)
//                                           , trigger: $scrollbarFlash
//                                )
//                            }
//                            if (isShowCoatingThicknessExp){
//                                TextDialog(isActive: $isShowCoatingThicknessExp,
//                                           titleArr: result?.result?.think_coating_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
//                                           description: (tongueCoatingThicknessDescription).localizedText(language: language)
//                                           , trigger: $scrollbarFlash
//                                )
//                            }
//                            if (isShowOtherFindingExp){
//                                TextDialog(isActive: $isShowOtherFindingExp,
//                                           titleArr: result?.result?.greasy_coating_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
//                                           description: (otherFindingDescription).localizedText(language: language)
//                                           , trigger: $scrollbarFlash
//                                )
//                            }
                            LoadingView(text: "loading".localizedString(language: language)).opacity(isLoading ? 1.0 : 0.0)
                        }
                        .alert(NSLocalizedString("saved_photo_msg", comment: ""), isPresented: $vm.showSavedPhotoAlert){
                            Button(NSLocalizedString("confirm", comment: ""), role: .cancel) { vm.showSavedPhotoAlert.toggle() }
                        }
                        .alert(isPresented: $isShowLoginDialog) {
                            Alert(
                                title: "hint".localizedText(language: language),
                                message: "please_login".localizedText(language: language),
                                primaryButton: .default(
                                    "notNow".localizedText(language: language),
                                    action: {
                                        isShowLoginDialog.toggle()
                                    }
                                ),
                                secondaryButton: .destructive(
                                    "go_to_login".localizedText(language: language),
                                    action: {
                                        isShowLoginDialog.toggle()
                                        tabViewSelection = 4
                                        onDismiss()
                                    }
                                )
                            )
                        }
                }
                .animation(.easeOut(duration: 0.16))
                .navigationBarBackButtonHidden()
                .onAppear(){
                    let inputString = result?.result?.diabetes_tongue_description_explain ?? ""
                    let pattern = "(<a href=\").*(\">)"
                    if let regex = try? NSRegularExpression(pattern: pattern),
                       !inputString.isEmpty {
                        let matches = regex.matches(in: inputString, range: NSRange(inputString.startIndex..., in: inputString))
                        if let firstMatch = matches.first,
                           let range = Range(firstMatch.range, in: inputString) {
                            let matchStr = String(inputString[range])
                            let link = matchStr.replacingOccurrences(of: "<a href=\"", with: "")
                                .replacingOccurrences(of: "\">", with: "")
                            let linkText = link.replacingOccurrences(of: "https://", with: "")
                            tongueDiabetesDescription = result?.result?.diabetes_tongue_description_explain?
                                .replacingOccurrences(of: "<a href=\"\(link)\">\(linkText)</a>", with: "[\(linkText)](\(link))") ?? ""
                        }
                        tongueBodyColorDescription = (result?.result?.tontue_color_description_explain ?? "")
                        tongueCoatingColorDescription = (result?.result?.coating_color_description_explain ?? "")
                        tongueCoatingThicknessDescription = (result?.result?.think_coating_description_explain ?? "")
                        otherFindingDescription = (result?.result?.think_coating_description_explain ?? "")
                    }
               
                    if let image = result?.image, let url = URL(string: image) {
                        vm.getData(from: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            vm.resultImage = data
                        }
                    }
                    let colorBarWidthCGFloat = geometry.size.width-horizontalPadding * 2.0
                    let indexCGFloat = CGFloat(Double(result?.result?.index ?? "0") ?? 0.0)
                    healthIndicatorOffsetX =  colorBarWidthCGFloat * indexCGFloat / 7.0
                    switch indexCGFloat {
                    case 0.0:
                        healthIndicatorOffsetX += 12.0
                    case 7.0:
                        healthIndicatorOffsetX -= 12.0
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func getCurrentDate() -> String{
        let today = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = (preferenceUtil.language == "en") ? "dd/MM/yyyy HH:mm" : "yyyy/MM/dd HH:mm"
        return formatter.string(from: today)
    }
}
