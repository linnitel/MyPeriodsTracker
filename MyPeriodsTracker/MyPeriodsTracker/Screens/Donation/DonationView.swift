//
//  DonationView.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 14/07/2023.
//

import SwiftUI
import StoreKit

struct DonationView: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	@StateObject var viewModel: DonationViewModel
	
	var body: some View {
		ZStack(alignment: .top) {
			BackgroundView()
			VStack {
				NavigationHeaderView(title: "Donations") {
					self.presentationMode.wrappedValue.dismiss()
				}
				ForEach(self.viewModel.products) { product in
					PaymentPresetView(price: product.displayPrice, imageName: self.viewModel.productsImages[product.id] ?? "", title: product.displayName, description: product.description) {
						self.viewModel.purchase(product: product)
					}
					.frame(height: 128)
					.padding(.bottom)
				}
				Spacer()
			}
			.padding([.leading, .trailing])
		}
		.navigationBarHidden(true)
		.modifier(BaseTextModifier())
		.onAppear {
			self.viewModel.loadProducts()
		}
	}
}

struct PaymentPresetView: View {
	let price: String
	let imageName: String
	let title: String
	let description: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			ButtonBackgroundView {
				HStack {
					Image(imageName)
						.resizable()
						.scaledToFit()
						.padding(5)
					VStack(alignment: .leading) {
						Text(self.title)
							.modifier(BoldTextModifier())
						Text(self.description)
							.foregroundColor(.black)
							.multilineTextAlignment(.leading)
							.padding([.trailing, .bottom])
						Text(self.price)
							.modifier(PriceTextModifier())
							.foregroundColor(.accentColor)
					}
					Spacer()
				}
			}
		}
	}
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView(viewModel: DonationViewModel())
    }
}
