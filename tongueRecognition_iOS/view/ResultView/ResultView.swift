//
//  ResultView.swift
//  tongueRecognition_iOS
//
//  Created by user on 2023/6/13.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.openURL) var openURL
    
    @StateObject private var vm = ResultViewVM()
    
    @Binding var isPageActive: Bool
    
    @Environment(PreferenceUtil.self) var preferenceUtil
    
    @Binding var language : String?
    
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
    @State var isShowTongueBodyColorExp = false
    @State var isShowCoatingColorExp = false
    @State var isShowCoatingThicknessExp = false
    @State var isShowOtherFindingExp = false
    
    @State var isLoading: Bool = false
    
    let horizontalPadding = 20.0
    
    @State var scrollbarFlash: Int = 0
    
    @State var isShowLoginDialog = false
    
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
                            let title = isAppointment ? "result_appointment" : "result_questionnaire"
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
                            ScrollView(showsIndicators:false){
                                VStack() {
                                    Group{
                                        HStack(){
                                            VStack{
                                                if let image = result?.image{
                                                    Button(action: {
                                                        if (tongueRecognition_iOSApp.loginModel != nil){
                                                            if (vm.resultImage != nil){
                                                                isShowFullPhoto.toggle()
                                                            }
                                                        } else{
                                                            isShowLoginDialog.toggle()
                                                        }
                                                    }){
                                                        if let img = vm.resultImage{
                                                            Image(uiImage: UIImage(data: img)!)
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
                                                if let image = vm.resultImage{
                                                    let title = "share_tongue".localizedString(language: language)
                                                    let item  = Image(uiImage: UIImage(data: image)!)
                                                    ShareLink(item: item, preview: SharePreview(title, image: item)){
                                                            DialogButtonView(text: "share_tongue".localizedString(language: language), width: 100, backgroundColor: Color("transparent"), borderColor: Color("toolbarBackground"), textColor: Color("toolbarBackground"), isTextBold: true,
                                                                             fontSize: .footnote, cornerRadius: 20
                                                            )
                                                        }
                                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                                                        .buttonStyle(ClickScaleDown())
                                                }
                                                Button(action: {
                                                    isPageActive.toggle()
                                                }){
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
                                    // Health condition index bar
                                    HStack{
                                        Text("result_tongue_health_index".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    ZStack(alignment: .leading){
                                        Image("result_color_bar")
                                            .resizable()
                                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                        Rectangle()
                                            .foregroundColor(Color("indicator_grey"))
                                            .frame(width: 3)
                                            .offset(x:healthIndicatorOffsetX)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                                    HStack{
                                        Text("result_tongue_health_index_good".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.footnote)
                                        Spacer()
                                        Text("result_tongue_health_index_bad".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.footnote)
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    // Diabetes tongue prob
                                    HStack{
                                        Button(action:{
                                            isShowDiabetesTongueExp.toggle()
                                        }){
                                            (
                                            Text(result?.result?.diabetes_tongue_description ?? "")
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            +
                                            Text((result?.result?.diabetes_prob?.replacingOccurrences(of: "\n\n", with: " ").replacingOccurrences(of: "\n", with: " ") ?? ""))
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                                .foregroundColor(Color("result_blue"))
                                            )
                                            .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    // Tongue body color
                                    HStack{
                                        Text("result_color1".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        Button(action:{
                                            isShowTongueBodyColorExp.toggle()
                                        }){
                                            Text((result?.result?.tontue_color_description?.replacingOccurrences(of: "\n\n", with: " ").replacingOccurrences(of: "\n", with: " ") ?? ""))
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                                .foregroundColor(Color("result_blue"))
                                        }
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    // Tongue Coating Colour
                                    HStack{
                                        Text("result_color2".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        Button(action:{
                                            isShowCoatingColorExp.toggle()
                                        }){
                                            Text((result?.result?.coating_color_description?.replacingOccurrences(of: "\n\n", with: " ").replacingOccurrences(of: "\n", with: " ") ?? ""))
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                                .foregroundColor(Color("result_blue"))
                                        }
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    // Tongue Coating Thickness
                                    HStack{
                                        Text("result_color3".localizedString(language: language))
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                        Button(action:{
                                            isShowCoatingThicknessExp.toggle()
                                        }){
                                            Text((result?.result?.think_coating_description?.replacingOccurrences(of: "\n\n", with: " ").replacingOccurrences(of: "\n", with: " ") ?? ""))
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                                .foregroundColor(Color("result_blue"))
                                        }
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    // Other findings
                                    if let otherFinding = result?.result?.greasy_coating_description?.replacingOccurrences(of: "\n\n", with: " ").replacingOccurrences(of: "\n", with: " "){
                                        HStack{
                                            "result_other".localizedText(language: language)
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                            Button(action:{
                                                isShowOtherFindingExp.toggle()
                                            }){
                                                Text(otherFinding)
                                                    .fontWeight(.bold)
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("result_blue"))
                                            }
                                            Spacer()
                                        }
                                        .opacity(otherFinding.isEmpty ? 0 : 1)
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                                    }
                                    // Click to see full explanation text
                                    HStack{
                                        "result_see_explanation".localizedText(language: language)
                                            .fontWeight(.regular)
                                            .font(.caption)
                                            .foregroundColor(Color("light_grey"))
                                        Spacer()
                                    }
                                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
                                    // Buttons
                                    Group{
                                        HStack(spacing:50){
                                            Button(action:{
                                                isAppointment = true
                                                url = Constant.RESULT_APPOINTMENT
                                                openURL(URL(string: url)!)
                                            }){
                                                DialogButtonView(text: "result_appointment".localizedString(language: language), width: 100, backgroundColor: Color("toolbarBackground"), borderColor: Color("toolbarBackground"), textColor: .white, isTextBold: true,
                                                                 fontSize: .callout, cornerRadius: 5
                                                )
                                            }
                                            .buttonStyle(ClickScaleDown())
                                            Button(action:{
                                                isAppointment = false
                                                url = "\(Constant.RESULT_QUESTIONNAIRE)?token=\(tongueRecognition_iOSApp.loginModel?.token ?? "")"
                                                openURL(URL(string: url)!)
                                            }){
                                                DialogButtonView(text: "result_questionnaire".localizedString(language: language), width: 100, backgroundColor: Color("toolbarBackground"), borderColor: Color("toolbarBackground"), textColor: .white, isTextBold: true,
                                                                 fontSize: .callout, cornerRadius: 5
                                                )
                                            }
                                            .buttonStyle(ClickScaleDown())
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 66, trailing: 20))
                                    }
                                }
                                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button(action:{isPageActive.toggle()}){
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
                            if (isShowFullPhoto){
                                ImageDialog(isActive: $isShowFullPhoto, image: vm.resultImage!)
                            }
                            if (isShowDiabetesTongueExp){
                                TextDialog(isActive: $isShowDiabetesTongueExp,
                                           titleArr: "diabetesTongueTitle".localizedString(language: language).replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (tongueDiabetesDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
                            if (isShowTongueBodyColorExp){
                                TextDialog(isActive: $isShowTongueBodyColorExp,
                                           titleArr: result?.result?.tontue_color_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (tongueBodyColorDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
                            if (isShowCoatingColorExp){
                                TextDialog(isActive: $isShowCoatingColorExp,
                                           titleArr: result?.result?.coating_color_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (tongueCoatingColorDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
                            if (isShowCoatingThicknessExp){
                                TextDialog(isActive: $isShowCoatingThicknessExp,
                                           titleArr: result?.result?.think_coating_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (tongueCoatingThicknessDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
                            if (isShowOtherFindingExp){
                                TextDialog(isActive: $isShowOtherFindingExp,
                                           titleArr: result?.result?.greasy_coating_description?.replacingOccurrences(of: "\n\n", with:"\n").components(separatedBy: "\n") ?? [""],
                                           description: (otherFindingDescription).localizedText(language: language)
                                           , trigger: $scrollbarFlash
                                )
                            }
                            LoadingView(text: "loading".localizedString(language: language)).opacity(isLoading ? 1.0 : 0.0)
                        }
                        .alert(NSLocalizedString("saved_photo_msg", comment: ""), isPresented: $vm.showSavedPhotoAlert){
                            Button(NSLocalizedString("confirm", comment: ""), role: .cancel) { vm.showSavedPhotoAlert.toggle() }
                        }
                        .alert(NSLocalizedString("please_login", comment: ""), isPresented: $isShowLoginDialog){
                            Button(NSLocalizedString("confirm", comment: ""), role: .cancel) { isShowLoginDialog.toggle() }
                        }
                }
                .animation(.easeOut(duration: 0.16))
                .navigationBarBackButtonHidden()
                .onAppear(){
                    let inputString = result?.result?.diabetes_tongue_description_explain ?? ""
                    let pattern = "(<a href=\").*(\">)"
                    if let regex = try? NSRegularExpression(pattern: pattern) {
                        let matches = regex.matches(in: inputString, range: NSRange(inputString.startIndex..., in: inputString))
                        let matchStrings = matches.map { match in
                            String(inputString[Range(match.range, in: inputString)!])
                        }
                        let link = (matchStrings[0] as String).replacingOccurrences(of: "<a href=\"", with: "")
                            .replacingOccurrences(of: "\">", with: "")
                        let linkText = link.replacingOccurrences(of: "https://", with: "")
                        tongueDiabetesDescription = result?.result?.diabetes_tongue_description_explain?.replacingOccurrences(of: "<a href=\"\(link)\">\(linkText)</a>", with: "[\(linkText)](\(link))") ?? ""
                        tongueDiabetesDescription += "\nHsu PC, Wu HK, Huang YC, Chang HH, Lee TC, Chen YP, Chiang JY, Lo LC. The tongue features associated with type 2 diabetes mellitus. Medicine. 2019 May 1;98(19):e15567."
                        tongueBodyColorDescription = (result?.result?.tontue_color_description_explain ?? "") + "\n\nSeerangaiyan K, Jüch F, Winkel EG. Tongue coating: Its characteristics and role in intra-oral halitosis and general health—A review. Journal of breath research. 2018 Mar 6;12(3):034001."
                        tongueCoatingColorDescription = (result?.result?.coating_color_description_explain ?? "") + "\n\nMore Ref for Heath of tongue coating : Evaluation of tongue coating indices. Oral diseases. 2007 Mar;13(2):177-80."
                        tongueCoatingThicknessDescription = (result?.result?.think_coating_description_explain ?? "") + "\n\nVan Gils LM, Slot DE, Van der Sluijs E, Hennequin‐Hoenderdos NL, Van der Weijden F. Tongue coating in relationship to gender, plaque, gingivitis and tongue cleaning behaviour in systemically healthy young adults. International journal of dental hygiene. 2020 Feb;18(1):62-72."
                        otherFindingDescription = (result?.result?.think_coating_description_explain ?? "") + "\n\nBalamanikandan P, Shetty P, Shetty U. Diabetic tongue–a review. Romanian Journal of Diabetes Nutrition and Metabolic Diseases. 2021 Jun 30;28(2):218-22."
                        
                    }
               
                    if let image = result?.image{
                        vm.getData(from: URL(string: image)!) { data, response, error in
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
        formatter.dateFormat = (preferenceUtil.language == "en") ? "yyyy-MMM-dd HH:mm" : "yyyy年MM月dd日 HH:mm"
        return formatter.string(from: today)
    }
}
