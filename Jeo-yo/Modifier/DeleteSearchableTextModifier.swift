//
//  DeleteSearchableTextModifier.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI

struct DeleteSearchableTextModifier: ViewModifier {
    @Binding var searchText: String
    let onClear: () -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .onChange(of: searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        onClear()
                    }
                }
        } else if #available(iOS 16, *) {
            content
                .onChange(of: searchText, perform: { value in
                    if value.isEmpty {
                        onClear()
                    }
                })
        }
    }
}


extension View {
    func detectSearchableTextDeleted(searchText: Binding<String>, onClear: @escaping () -> Void) -> some View {
        self.modifier(DeleteSearchableTextModifier(searchText: searchText, onClear: onClear))
    }
}
