//
//  SettingsView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 20/06/2023.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@Binding var startDate: Date
	@Binding var cycle: Int
	@Binding var period: Int

    var body: some View {
		NavigationView {
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
						Text("Settings")
					}
					.padding(.bottom, 16)
					Group {
						SettingsItemView(text: "Cycle length", value: cycle)
						SettingsItemView(text: "Period length", value: period)
						LastDateItemView(value: DateCalculatiorService.shared.getLastDate(self.startDate))
						NotificationsItem()
					}
					.padding([.leading, .trailing], 24)
					Spacer()
					LowerButton(text: "Rate the app in AppStore", action: {})
				}
			}
			.navigationBarHidden(true)
			.modifier(BaseTextModifier())
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		SettingsView(startDate: .constant(Date()), cycle: .constant(5), period: .constant(30))
    }
}

struct SettingsItemView: View {
	let text: String
	let value: Int

	var body: some View {
		VStack {
			HStack {
				Text(LocalizedStringKey(self.text))
				Spacer()
				Text("\(value) days")
					.foregroundColor(.accentColor)
			}
			DividerLineView()
		}
		.frame(height: 56)
	}
}

struct LastDateItemView: View {
	let value: String

	var body: some View {
		VStack {
			HStack {
				Text("Next period")
				Spacer()
				Text(LocalizedStringKey(value))
					.foregroundColor(.accentColor)
			}
			DividerLineView()
		}
		.frame(height: 56)
	}
}

struct NotificationsItem: View {
	var body: some View {
		HStack {
			Text("Notifications")
			Spacer()
			NavigationLink(destination: NotificationSettings()) {
				Image(systemName: "chevron.right")
					.foregroundColor(Color(UIColor(named: "secondButtonText") ?? .gray))
			}
		}
		.frame(height: 46)
	}
}

