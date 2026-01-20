//
//  tongueScan_iOSApp.swift
//  tongueScan_iOS
//
//  Created by user on 2023/6/8.
//

import SwiftUI

@main
struct tongueScan_iOSApp: App {

    @State var preferenceUtil = PreferenceUtil()
    
    static var loginModel: LoginModel? = nil
    
    init(){
        preferenceUtil.language = "zh-Hans"
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(preferenceUtil)
                .preferredColorScheme(preferenceUtil.theme ?? .light)
        }
    }
}

extension String {
    
    func localizedString(language:String?) -> String{
        let path = Bundle.main.path(forResource: language ?? "zh-Hans", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func localizedText(language:String?) -> Text{
        let path = Bundle.main.path(forResource: language ?? "zh-Hans", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return Text(LocalizedStringKey(self), tableName: nil, bundle: bundle!, comment: "")
    }
}

struct KeyboardProvider: ViewModifier {
    
    var keyboardHeight: Binding<CGFloat>
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                       perform: { notification in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                            
                self.keyboardHeight.wrappedValue = keyboardRect.height
                
            }).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                         perform: { _ in
                self.keyboardHeight.wrappedValue = 0
            })
    }
}


public extension View {
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardProvider(keyboardHeight: state))
    }
}


