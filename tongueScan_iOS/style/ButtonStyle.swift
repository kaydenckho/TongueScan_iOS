//
//  ButtonStyle.swift
//  tongueScan_iOS
//
//  Created by kayd3nckh on 21/2/2024.
//

import SwiftUI

struct ClickScaleDown: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.75 : 1)
            .animation(.linear(duration: 0.1))
    }
}

struct ClickScaleUp: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 1.25 : 1)
            .animation(.linear(duration: 0.1))
    }
}
