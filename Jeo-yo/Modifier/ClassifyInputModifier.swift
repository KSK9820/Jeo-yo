//
//  ClassifyInputModifier.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/25/24.
//

import SwiftUI

struct ClassifyInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
    }
}

extension View {
    func classifyInputStyle() -> some View {
        self.modifier(ClassifyInputModifier())
    }
}
