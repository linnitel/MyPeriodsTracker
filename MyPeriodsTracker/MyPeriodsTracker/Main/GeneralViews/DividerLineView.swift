//
//  DividerLineView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 21/06/2023.
//

import SwiftUI

struct DividerLineView: View {
    var body: some View {
		ZStack(alignment: .top) {
			RoundedRectangle(cornerRadius: 2)
				.fill(Color(UIColor(named: "line") ?? .white))
				.frame(height: 2)
			RoundedRectangle(cornerRadius: 1)
				.fill(Color(UIColor(named: "lineShadow") ?? .gray))
				.frame(height: 1)
				.padding([.leading, .trailing], 1)
		}
    }
}

struct DividerLineView_Previews: PreviewProvider {
    static var previews: some View {
        DividerLineView()
    }
}
