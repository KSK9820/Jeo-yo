//
//  BindingUtilities.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/25/24.
//

import SwiftUI

func optionalBinding<T: Equatable>(for optionalValue: Binding<T?>, defaultValue: T) -> Binding<T> {
    Binding<T>(
        get: { optionalValue.wrappedValue ?? defaultValue },
        set: { optionalValue.wrappedValue = $0 == defaultValue ? nil : $0 }
    )
}
