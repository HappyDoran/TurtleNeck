//
//  PIPView.swift
//  TurtleNeck
//
//  Created by Doran on 8/4/24.
//

import SwiftUI

struct PIPView: View {
    @Environment(\.appDelegate) var appDelegate: AppDelegate?
    
    @Binding var isMute: Bool
    @ObservedObject var motionManager: HeadphoneMotionManager
    
    var body: some View {
        NavigationStack{
            TurtleView(motionManager: motionManager)
                .offset(x: -16, y: 12)
                .padding(.top, 16)
        }
        .frame(width: 286,height: 130)
        .padding(.horizontal,12)
        .toolbar() {
            Spacer()
            HStack(spacing: 10){
                Spacer()
                
                Button(action: {
                    isMute.toggle()
                }){
                    Image(systemName: isMute ? "speaker" : "speaker.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16,height: 16)
                        .foregroundColor(.primary)
                }.buttonStyle(.plain)
            }
            .padding(.trailing, 12)
            
        }
        .onAppear{
            motionManager.startUpdates()
        }
//        .onDisappear {
//            motionManager.stopUpdates()
//        }
    }
}
