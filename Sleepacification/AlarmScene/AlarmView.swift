//
//  AlarmView.swift
//  Sleepacification
//
//  Created by Dmitriy Lupych on 16.05.2020.
//  Copyright © 2020 Dmitry Lupich. All rights reserved.
//

import SwiftUI

struct AlarmView: View {
    @EnvironmentObject var alarmPlayer: AlarmPlayer
    @ObservedObject var viewModel: AlarmViewModel

    var body: some View {
        VStack {
            HStack(spacing: 32) {
                Text("Hours")
                Text("Minutes")
            }
            HStack {
                Picker(selection: $viewModel.selectedHour, label: EmptyView()) {
                    ForEach(0..<viewModel.hoursCount) {
                        Text(self.viewModel.hourTitleFor($0))
                    }
                }
                Picker(selection: $viewModel.selectedMinute, label: EmptyView()) {
                    ForEach(0..<viewModel.minutesCount) {
                        Text(self.viewModel.minuteTitleFor($0))
                    }
                }
            }
            Button("Set an alarm on: \(viewModel.selectedHourTitle()):\(viewModel.selectedMinuteTitle())") {
                self.alarmPlayer.alarmDate = self.viewModel.setAlarm()
            }
            VStack {
                if viewModel.alarmIsSet {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Alarm is set!")
                    }
                }
            }
        }.alert(isPresented: $viewModel.showNotificationPermission) {
            Alert(title: Text("Notifications disabled"),
                  message: Text("Allow local notifications?"),
                  primaryButton: .default(Text("To Settings"), action: {
                    self.viewModel.toSettings()
                  }), secondaryButton: .default(Text("Cancel"), action: {
                    self.viewModel.showNotificationPermission = false
                  })
            )
        }.onAppear {
            self.viewModel.onAppear()
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView(viewModel: AlarmViewModel())
    }
}
