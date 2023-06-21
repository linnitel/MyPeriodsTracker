//
//  NotificationSettings.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI

struct NotificationSettings: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@State var notificationsActive: Bool = true
	@State var notificationsList: [NotificationsList] = [
		NotificationsList(id: "One day before period", subscribe: true),
		NotificationsList(id: "Start of the period", subscribe: true),
		NotificationsList(id: "Ovulation", subscribe: true)
	]
	@State var notificationTime: Date = Date()

    var body: some View {
		ZStack(alignment: .top) {
			BackgroundView()
			VStack {
				ZStack(alignment: .center) {
					HStack(alignment: .center) {
						Button(action: {
							self.presentationMode.wrappedValue.dismiss()
						}) {
							Image(systemName: "arrow.left")
								.padding()
								.foregroundColor(.black)
						}
						Spacer()
					}
					Text("Notifications")
				}
				Group {
					NotificationsToggleItem(text: "Notifications", value: $notificationsActive)
					NotificationsTimeItem(text: "Send at", time: $notificationTime)
						.padding(.bottom, 40)
					ForEach($notificationsList) { $list in
						NotificationsToggleItem(text: list.id, value: $list.subscribe)
					}
				}
				.padding([.leading, .trailing], 24)
			}
		}
		.navigationBarHidden(true)
		.modifier(BaseTextModifier())
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettings()
    }
}

struct NotificationsToggleItem: View {
	let text: String

	@Binding var value: Bool

	var body: some View {
		VStack {
			Toggle(LocalizedStringKey(text), isOn: $value)
				.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				.padding([.bottom, .top], 16)
			DividerLineView()
		}
	}
}

struct NotificationsTimeItem: View {
	let text: String
	@State var isShown: Bool = false

	@Binding var time: Date
	
	var body: some View {
		VStack {
			HStack {
				Text(LocalizedStringKey(text))
				Spacer()
				Button {
					self.isShown.toggle()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 10)
							.frame(width: 80, height: 40)
							.foregroundColor(.black.opacity(0.08))
						Text(time, style: .time)
					}
				}
			}
			.frame(height: 54)
			if isShown {
				DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
					.datePickerStyle(WheelDatePickerStyle())
			}
		}
	}

}
