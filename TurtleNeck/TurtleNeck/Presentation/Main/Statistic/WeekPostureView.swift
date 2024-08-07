//
//  WeekPostureView.swift
//  TurtleNeck
//
//  Created by Doran on 7/27/24.
//

import SwiftUI
import SwiftData

struct WeekPostureView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var statistics: [NotiStatistic] // NotiStatistic 배열

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("지난 7일간")
                .font(.pretendardBold10)
                .foregroundColor(.black)
                .padding(.top, 17)
            Text("시간당 평균적으로 받은 알림 횟수")
                .font(.pretendardBold10)
                .foregroundColor(.black)
            
            HStack(alignment: .bottom) {
                ForEach(statistics) { data in // data는 NotiStatistic 타입
                    let height = getHeightStatistic(day: data) // data를 NotiStatistic으로 전달
                    VStack(spacing: 2) {
                        if data.notiCount == 0 {
                            Text("no data")
                                .font(.pretendardMedium8)
                                .foregroundColor(.chevron)
                        } else {
                            let averageAlerts = Double(data.notiCount) * 3600 / Double(data.time)
                            Text(String(format: "%.1f", averageAlerts))
                                .font(.pretendardMedium10)
                                .foregroundColor(Color.chart)
                        }
                        Rectangle()
                            .fill(Color.chart)
                            .frame(width: 16, height: CGFloat(height))
                            .padding(.horizontal, 4.5)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 20,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 20
                                )
                            )
                        Text(formatDate(data.date))
                            .font(.pretendardRegular10)
                            .foregroundColor(.black)
                            .frame(width: 29)
                    }
                }
            }
            .frame(width: 251, height: 120)
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        }
    }
}

extension WeekPostureView {
    private func getMaxCount(from statistics: [NotiStatistic]) -> Int? {
        return statistics
            .filter { $0.time > 0 }
            .map { $0.notiCount * 3600 / $0.time }
            .max()
    }
    
    private func getHeightStatistic(day: NotiStatistic) -> Double {
        guard let maxCount = getMaxCount(from: statistics) else {
            return 0
        }

        if day.time == 0 {
            return 0
        }

        let calculatedHeight = Double(day.notiCount) * 3600 / Double(day.time)
        let heightRatio = calculatedHeight / Double(maxCount)
        return max(0, min(heightRatio * 88, 88))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
