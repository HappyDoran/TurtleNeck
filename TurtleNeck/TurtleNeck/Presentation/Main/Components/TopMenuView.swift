//
//  TopMenuView.swift
//  TurtleNeck
//
//  Created by Doran on 8/2/24.
//

import SwiftUI

struct TopMenuView: View {
    @State var isMute: Bool = false
    @State private var alwaysOnTopWindow: NSWindow?
    @State private var settingWindow: NSWindow?
    
    var body: some View {
        HStack {
            Button(action: {
                isMute.toggle()
            }){
                Image(systemName: isMute ? "speaker" : "speaker.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16,height: 16)
                    .foregroundColor(.primary)
            }.buttonStyle(.plain)
            
            Button(action: {
                //            openAlwaysOnTopWindow()
            }){
                Image(systemName:"macwindow.on.rectangle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17,height: 17)
                    .foregroundColor(.primary)
            }.buttonStyle(.plain)
            
            Button(action: {
                //            openEmptyWindow()
            }) {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16,height: 16)
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
        }
    }
}

//extension TopMenuView {
//    private func openAlwaysOnTopWindow() {
//        DispatchQueue.main.async {
//            let newWindow = NSWindow(
//                contentRect: NSRect(x: 100, y: 100, width: 286, height: 160),
//                styleMask: [.titled, .closable, .resizable],
//                backing: .buffered, defer: false)
//            
//            newWindow.titlebarAppearsTransparent = true
//            newWindow.titleVisibility = .hidden
//            newWindow.backgroundColor = .white
//            
//            newWindow.center()
//            newWindow.level = .floating
//            newWindow.isMovableByWindowBackground = true
//            newWindow.setFrameAutosaveName("AlwaysOnTopWindow")
//            newWindow.makeKeyAndOrderFront(nil)
//            
//            alwaysOnTopWindow = newWindow
//            isAlwaysOnTopWindowOpen = true
//            
//            newWindow.contentView = NSHostingView(rootView: AlwaysOnTopView(isMute: $isMute, alwaysOnTopWindow: $alwaysOnTopWindow))
//            
//            newWindow.delegate = WindowDelegate {
//               
//                isAlwaysOnTopWindowOpen = false
//            }
//        }
//    }
//    
//    private func openEmptyWindow() {
//        DispatchQueue.main.async {
//            let newWindow = NSWindow(
//                contentRect: NSRect(x: 100, y: 100, width: 560, height: 712),
//                styleMask: [.titled, .closable, .resizable],
//                backing: .buffered, defer: false)
//            
//            newWindow.title = "TurtleNeck"
//            
//            newWindow.center()
//            newWindow.level = .normal
//            newWindow.isMovableByWindowBackground = true
//            newWindow.setFrameAutosaveName("SettingWindow")
//            newWindow.makeKeyAndOrderFront(nil)
//            
//            settingWindow = newWindow
//            isSettingWindowOpen = true // 창이 열렸으므로 상태 업데이트
//            
//            newWindow.contentView = NSHostingView(rootView: SettingView(settingWindow: $settingWindow))
//            
//            newWindow.delegate = WindowDelegate {
//                // 창이 닫힐 때 상태 업데이트
//                isSettingWindowOpen = false
//            }
//        }
//    }
//}
