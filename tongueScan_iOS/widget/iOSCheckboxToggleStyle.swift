//
//  iOSCheckboxToggleStyle.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 6/8/2024.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                configuration.label
            }
        })
    }
}
