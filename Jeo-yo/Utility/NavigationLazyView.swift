//
//  NavigationLazyView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/23/24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let closure: () -> Content
    
    var body: some View {
        closure()
    }
    
    init(_ closure: @autoclosure @escaping () -> Content) {
        self.closure = closure
    }
}

