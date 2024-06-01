//
//  OrderServcie.swift
//  CheckoutInterview
//

import Foundation
import Combine

class CheckoutService {
    private let session = FakeNetworkSession() 
    @Published
    var order: Order?
    @Published
    var submit: Submit?

    func fetchOrder() {
        session.getOrder { [weak self] data in
            print(String(data: data, encoding: .utf8)!)
            self?.handleOrder(data: data)
        }
    }

    func submitOrder() {
        session.submitOrder(orderId: "123") { data in
            print(String(data: data, encoding: .utf8)!)
            self.handleSubmit(data: data)
        }
    }

    func handleOrder(data: Data)  {
        do {
            order = try JSONDecoder().decode(Order.self, from: data)
        } catch {
            print(error)
        }
    }

    func handleSubmit(data: Data)  {
        do {
            submit = try JSONDecoder().decode(Submit.self, from: data)
        } catch {
            print(error)
        }
    }
}

struct Order: Codable {
    let id: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, Hashable {
    let name: String
    let displayPrice: String?

    enum CodingKeys: String, CodingKey {
        case name
        case displayPrice = "display_price"
    }
}

struct Submit: Codable {
    let status: String
}
