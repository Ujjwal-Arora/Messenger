//
//  BoxViewModifier.swift
//  AirBnB
//
//  Created by Ujjwal Arora on 16/09/24.
//

import Foundation
import SwiftUI

struct BoxViewModifier : ViewModifier {
    let backgroundColor : Color
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}
