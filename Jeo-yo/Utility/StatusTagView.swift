//
//  StatusTagView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/28/24.
//

import SwiftUI

struct StatusTagView: View {
    var totalStageCount: Int
    var currentStage: Int
    var step: Step
    
    var body: some View {
        let color = gradientColors(count: totalStageCount)[currentStage]

        Text(step.name)
            .font(.callout)
            .foregroundColor(.gray)
            .bold()
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(color)
            )
    }
}

//#Preview {
//    StatusTagView()
//}
