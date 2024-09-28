//
//  ApplicantContentView.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/27/24.
//

import SwiftUI

struct ApplicantContentView: View {
    @ObservedObject var viewModel: ApplicantContentViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .center) {
                if let currentStep = viewModel.currentStep {
                    StatusTagView(totalStageCount: viewModel.totalStepsCount, currentStage: currentStep.index, step: currentStep.step)
                } else {
                    StatusTagView(totalStageCount: 0, currentStage: 0, step: Step(name: "상시 모집", description: "", period: ApplicationPeriod()))
                }
            }
            .frame(width: 100)
            .frame(maxHeight: .infinity)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.content.company)
                        .bold()
                        .padding(.vertical)
                    Group {
                        Text(viewModel.content.applicationPeriods.startDate?.toString(format: .yyyymmdd_HHmm) ?? "")
                        Text(" ~ \(viewModel.content.applicationPeriods.endDate?.toString(format: .yyyymmdd_HHmm) ?? "")")
                    }
                    .font(.footnote)
                    .fontWeight(.light)
                }
                .padding([.leading, .bottom])
                
                Spacer()
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 15)
        .padding()
    }
}
