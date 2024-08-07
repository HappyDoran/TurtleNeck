//
//  MainView.swift
//  TurtleNeck
//
//  Created by 박준우 on 7/26/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.appDelegate) var appDelegate: AppDelegate?
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var motionManager = HeadphoneMotionManager()
    @State var isRealTime: Bool = true
    @State var isMute: Bool = false
    @State private var lastCheckedDate = Date()
    @State private var wearingStartTime: Date?
    
    @Query var statistic: [NotiStatistic]
    
    @State var characterNotiManager : CharacterNotiManager = {
        let screenSize = NSScreen.main!.frame
        let viewSize = CGSize(width: 150, height: 200)
        let position = NSRect(x: screenSize.size.width - viewSize.width, y: -viewSize.height, width: viewSize.width, height: viewSize.height)

        let imgName = "CharacterNoti"
        return CharacterNotiManager(position: position, imgName: imgName)
    }()

    var body: some View {
        VStack(spacing: 0){
            HStack(alignment: .center, spacing: 10){
                Spacer()
                
                segmentView.padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 16))
                
                TopMenuView(action: {
                    appDelegate?.openAlwaysOnTopView(isMute: $isMute, motionManager: motionManager)
                }, isMute: $isMute, motionManager: motionManager)
                
            }
            .padding(.top, 12)
            
            showView(isRealTime: isRealTime)
        }
        .padding(.horizontal,12)
        .background(.white)
        .frame(width: 348,height: 232)
        .onAppear {
            motionManager.startUpdates()
            //            checkDateChange()
            //
            //            print(statistic.count)
        }
        //        .onChange(of: lastCheckedDate) { _, _ in
        //            checkDateChange()
        //        }
        .onChange(of: motionManager.currentState) { _, _ in
            if let currentState = motionManager.currentState {
                switch currentState {
                case .good:
                    // 설정된 노티 삭제 후 재설정(.good => 1초 후)
                    NotificationManager().removeTimeNoti()
                    NotificationManager().settingTimeNoti(state: .good)
                    
                    // 설정된 캐릭터 노티 삭제
                    characterNotiManager.removeCharacterNoti()
                    
                case .bad:
                    if let notiStatistic = statistic.last {
                        notiStatistic.notiCount = notiStatistic.notiCount + 1
                    }
                    
                    // 노티 설정(.bad => 5초 후)
                    NotificationManager().settingTimeNoti(state: .bad)
                    
                case .worse:
                    // 노티 설정(.worse => 1초 후)
                    if let notiStatistic = statistic.last {
                        notiStatistic.notiCount = notiStatistic.notiCount + 1
                    }
                    NotificationManager().settingTimeNoti(state: .worse)
                    
                    // 캐릭터 노티 설정
                    characterNotiManager.setCharacterNoti()
                }
            }
        }
        
        .onChange(of: motionManager.isConnected) { isConnected in
            if isConnected {
                wearingStartTime = Date()
                checkAndAddTodayData() // isConnected가 true일 때 호출
            }
            else {
                if let startTime = wearingStartTime {
                    let endTime = Date()
                    let wearingDuration = Int(endTime.timeIntervalSince(startTime))
                    
                    let today = Calendar.current.startOfDay(for: endTime)
                    
                    let existingStatistic = statistic.filter { $0.date == today }.first
                    
                    if let lastStatistic = statistic.last {
                        lastStatistic.time += wearingDuration
                    }
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("저장 중 오류 발생: \(error)")
                    }
                }
                
                wearingStartTime = nil // 착용 시간 초기화
            }
        }
    }
    
    private var segmentView: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(width: 140, height: 22)
                .shadow(radius: 1)
        
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    isRealTime = true
                }) {
                    ZStack {

                        RoundedRectangle(cornerRadius: 8)
                            .fill(isRealTime ?  Color.iconHoverBG : .white)

                        Text("실시간")
                            .font(.pretendardRegular13)
                            .foregroundColor(isRealTime ? .primary : .chevron)
                    }
                    .frame(width: 69.5, height: 22)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    isRealTime = false
                }) {
                    ZStack {

                        RoundedRectangle(cornerRadius: 8)
                            .fill(isRealTime ? .white : Color.iconHoverBG)

                        Text("통계")
                            .font(.pretendardRegular13)
                            .foregroundColor(isRealTime ? .chevron : .primary)
                    }
                    .frame(width: 69.5, height: 22)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

}

extension MainView {
    @ViewBuilder
    private func showView(isRealTime: Bool) -> some View {
        if isRealTime {
            RealTimePostureView(motionManager: motionManager)
        }
        
        else {
            StatisticView(motionManager: motionManager)
        }
    }
}

extension MainView {
    
    private func checkDateChange() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // 마지막 체크한 날짜와 현재 날짜의 년, 월, 일이 다르면 날짜 변경 감지
        if !calendar.isDate(lastCheckedDate, inSameDayAs: currentDate) {
            addNotiStatistic(for: currentDate)
        }
        
        lastCheckedDate = currentDate
    }
    
    private func addNotiStatistic(for date: Date) {
        // NotiStatistic의 새 항목 추가
        let newStatistic = NotiStatistic(date: date)
        modelContext.insert(newStatistic)
        print("날짜 변경! statistic 추가됨")
        
        // statistic 배열의 길이가 7을 초과하면 첫 번째 요소 삭제
        if statistic.count > 7 {
            if let firstStatistic = statistic.first {
                modelContext.delete(firstStatistic)
            }
        }
    }
    
    private func checkAndAddTodayData() {
        let today = Calendar.current.startOfDay(for: Date())
        let todayDataExists = statistic.contains { Calendar.current.isDate($0.date, inSameDayAs: today) }
        
        if !todayDataExists {
            // 오늘 데이터가 없으면 새 데이터 추가
            let newTodayData = NotiStatistic(date: today)
            modelContext.insert(newTodayData)
            print("오늘에 해당하는 데이터가 추가되었습니다.")
        }
        
        // 데이터 갯수가 7개를 초과할 경우 제일 오래된 데이터 삭제
        if statistic.count > 7 {
            guard let firstItem = statistic.first else { return } // 첫 번째 아이템 확인
            modelContext.delete(firstItem) // 모델 컨텍스트에서 삭제
            print("가장 오래된 데이터가 삭제되었습니다.")
        }
    }
}


#Preview {
    MainView()
}
