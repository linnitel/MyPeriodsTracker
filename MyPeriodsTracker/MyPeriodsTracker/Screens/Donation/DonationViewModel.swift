//
//  DonationViewModel.swift
//  MyPeriodsTracker
//
//  Created by Julia Martcenko on 17/07/2023.
//

import Foundation
import StoreKit
import os

class DonationViewModel: ObservableObject {
	let productIds = ["donation_cup", "donation_pad", "donation_pants"]
	let productsImages = ["donation_cup": "cup", "donation_pad": "pad", "donation_pants": "pants"]

	let logger = Logger (subsystem: "Reddy", category: "DonationsView")

	@Published var products: [Product] = []

	func loadProducts() {
		Task {
			do {

				let products = try await Product.products(for: productIds)
				logger.log("products are requested: \(products)")
				DispatchQueue.main.async {
					self.products = products
				}
			} catch {
				logger.error("Can't fetch any products due to the error: \(error)")
			}
		}
	}

	func purchase(product: Product) {
		Task {
			do {
				let result = try await product.purchase()
				switch result {
					case .pending:
						logger.log("the purchase is pending")
					case .success(_):
						logger.log("the product is purchased successfuly")
					case .userCancelled:
						logger.log("user canceled the purchase")
					@unknown default:
						logger.error("unknown purchase status")
				}
			} catch {
				logger.error("Can't purchase product because of error: \(error)")
			}
		}
	}
}
