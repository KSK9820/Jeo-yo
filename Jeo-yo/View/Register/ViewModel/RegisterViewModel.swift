//
//  RegisterViewModel.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/21/24.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    
    private let serviceManager = ServiceManager()

    private var cancellables = Set<AnyCancellable>()

    var input = Input()
    
    struct Input {
       
    }
    
    init() {
       
    }
    
}
