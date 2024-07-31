//
//  WeekPostureView.swift
//  TurtleNeck
//
//  Created by Doran on 7/27/24.
//

import SwiftUI

struct WeekPostureView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("지난 7일간")
                .font(.pretendardBold10)
                .foregroundColor(.black)
                .padding(.top, 8)
            Text("시간당 평균적으로 받은 알림 횟수")
                .font(.pretendardBold10)
                .foregroundColor(.black)
            
            HStack(alignment: .bottom){
                ForEach(0..<7) { _ in
                    VStack{
                        Text("숫자")
                            .font(.pretendardMedium10)
                            .foregroundColor(Color.chart)
                        
                        Rectangle()
                            .fill(Color.chart)
                            .frame(width: 16, height: CGFloat(60))
                            .padding(.horizontal, 4.5)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 20,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 20
                                )
                            )
                        Text("07/31").font(.pretendardRegular10).foregroundColor(.black)
                            .frame(width: 29)
                    }
                }
            }
            .frame(width: 251,height: 120)
            .padding(.top, 16)
        }
    }
}

#Preview {
    WeekPostureView()
}
