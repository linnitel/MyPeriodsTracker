//
//  NotificationSettings.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI

struct NotificationSettings: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@ObservedObject var viewModel: NotificationSettingsViewModel

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
					NotificationsToggleItem(text: "Notifications", key: "NotificationsActive", value: $viewModel.notificationsActive) {
//						if self.viewModel.isNotFirstTime {
//							if let settingsURL = URL(string: UIApplication.openSettingsURLString){
//								UIApplication.shared.open(settingsURL)
//							}
//						} else {
//							self.viewModel.isNotFirstTime = true
//							UserDefaults.standard.set(true, forKey: "IsNotFirstTimeNotification")
						self.viewModel.notifications.notificationRequest()
//						}
					}
					NotificationsTimeItem(text: "Send at", time: $viewModel.notificationTime)
						.padding(.bottom, 40)
//					ForEach($viewModel.notificationsList) { $list in
//						NotificationsToggleItem(text: list.id, key: list.key, value: $list.subscribe)
//					}
				}
				.padding([.leading, .trailing], 24)
			}
		}
		.navigationBarHidden(true)
		.modifier(BaseTextModifier())
		.onAppear() {
			UNUserNotificationCenter.current().getNotificationSettings { (settings) in
				DispatchQueue.main.async {
					switch settings.authorizationStatus {
						case .notDetermined, .denied, .provisional, .ephemeral:
							self.viewModel.notificationsActive = false
						case .authorized:
							self.viewModel.notificationsActive = true
						@unknown default:
							self.viewModel.notificationsActive = false
					}
				}
			}
		}
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
		NotificationSettings(viewModel: NotificationSettingsViewModel())
    }
}

struct NotificationsToggleItem: View {
	let text: String
	let key: String

	@Binding var value: Bool

	var action: (() -> Void)?

	var body: some View {
		VStack {
			Toggle(LocalizedStringKey(text), isOn: $value)
				.toggleStyle(SwitchToggleStyle(tint: .accentColor))
				.padding([.bottom, .top], 16)
				.onChange(of: value) { value in
					UserDefaults.standard.set(value, forKey: key)
					if let action = action {
						action()
					}
				}
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
