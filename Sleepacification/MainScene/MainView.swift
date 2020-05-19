//
//  MainView.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 17.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var alarmPlayer: AlarmPlayer
    @State private var isAlarmPresented = false
    
    var body: some View {
        VStack(spacing: 32) {
            Text(verbatim: alarmPlayer.appState.title)
                .font(.headline)
            button(title: "Alarm") {
                self.isAlarmPresented.toggle()
            }
            .sheet(isPresented: $isAlarmPresented) {
                AlarmView(viewModel: AlarmViewModel()).environmentObject(self.alarmPlayer)
            }
            button(title: self.alarmPlayer.isPlayerStarted ? "Pause" : "Start") {
                self.alarmPlayer.isPlayerStarted.toggle()
            }
            Text("Sleep timer: " + (alarmPlayer.sleepTimer/60).toString() + " minutes")
            Slider(value: $alarmPlayer.sleepTimer, in: 0...1500, step: 300).padding(16)
        }.onAppear {
            self.alarmPlayer.askRecordingPermission = ()
        }
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .foregroundColor(.white)
            .padding([.leading, .trailing], 16)
            .padding([.top, .bottom], 8)
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
