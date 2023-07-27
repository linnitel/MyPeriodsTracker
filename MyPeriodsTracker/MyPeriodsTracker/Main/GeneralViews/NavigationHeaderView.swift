//
//  NavigationHeaderView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 14/07/2023.
//

import SwiftUI

struct NavigationHeaderView: View {
	let title: String
	let action: () -> Void

    var body: some View {
		ZStack(alignment: .center) {
			HStack(alignment: .center) {
				Button(action: self.action) {
					Image(systemName: "arrow.left")
						.padding()
						.foregroundColor(.black)
				}
				Spacer()
			}
			Text(self.title)
		}
    }
}

struct NavigationHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationHeaderView(title: "Donation", action: {})
    }
}
