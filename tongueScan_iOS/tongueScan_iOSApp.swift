//
//  tongueScan_iOSApp.swift
//  tongueScan_iOS
//
//  Created by user on 2023/6/8.
//

import SwiftUI
import UIKit

@main
struct tongueScan_iOSApp: App {

    @State var preferenceUtil = PreferenceUtil()
    
    static var loginModel: LoginModel? = nil
    
    init(){
        // Restore rectangular full-width tab bar (disable floating style) - must be first
        UserDefaults.standard.register(defaults: ["UseFloatingTabBar": false])
        UserDefaults(suiteName: "com.apple.UIKit")?.set(false, forKey: "UseFloatingTabBar")
        
        preferenceUtil.language = "zh-Hans"
        
        // Top bar & bottom bar: match layout font sizes
        if #available(iOS 15.0, *) {
            // Top bar: title font ~20pt
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20)]
            navBarAppearance.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20)]
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().compactAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            
            // Bottom tab bar: font 14pt, selected color matches icon
            let tabBarFont = UIFont.systemFont(ofSize: 14)
            let selectedColor = UIColor(named: "toolbarBackground") ?? .systemGreen
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: tabBarFont]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: tabBarFont, .foregroundColor: selectedColor]
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.font: tabBarFont]
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.font: tabBarFont, .foregroundColor: selectedColor]
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().tintColor = selectedColor
        }
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
    
    func localizedString(language: String?) -> String {
        let locale = language ?? "zh-Hans"
        let bundle: Bundle
        if let path = Bundle.main.path(forResource: locale, ofType: "lproj"), let locBundle = Bundle(path: path) {
            bundle = locBundle
        } else {
            bundle = Bundle.main
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
    }
    
    func localizedText(language: String?) -> Text {
        let locale = language ?? "zh-Hans"
        let bundle: Bundle
        if let path = Bundle.main.path(forResource: locale, ofType: "lproj"), let locBundle = Bundle(path: path) {
            bundle = locBundle
        } else {
            bundle = Bundle.main
        }
        return Text(LocalizedStringKey(self), tableName: nil, bundle: bundle, comment: "")
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


