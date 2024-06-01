//
//  FakeNetworkSession.swift
//  CheckoutInterview
//

import Foundation
import Combine

/// Candidates should not modify this file or class
class FakeNetworkSession {
    enum TaskType {
        case order
        case submission
    }

    let fileURLOrderResponse: URL = {
        let path = Bundle.main.path(forResource: "OrderResponse", ofType: "json")!
        return URL(fileURLWithPath: path)
    }()

    let fileURLSubmissionResponse: URL = {
        let path = Bundle.main.path(forResource: "SubmissionResponse", ofType: "json")!
        return URL(fileURLWithPath: path)
    }()

    private static let queue = DispatchQueue(label: "com.doordash.random-queue", qos: .background)

    /// Candidates should not modify this method
    func getOrder(completionHandler: @escaping (Data) -> Void) {
        FakeNetworkSession.queue.asyncAfter(deadline: .now() + 1.0) {
            let data = try! Data(contentsOf: self.fileURLOrderResponse)
            completionHandler(data)
        }
    }

    /// Candidates should not modify this method
    func submitOrder(orderId: String, completionHandler: @escaping (Data) -> Void) {
        print("Submitting order with id: \(orderId)")
        FakeNetworkSession.queue.asyncAfter(deadline: .now() + 1.0) { [self] in
            let data = try! Data(contentsOf: fileURLSubmissionResponse)
            completionHandler(data)
        }
    }

}

/// Candidates should not modify this class
struct FakeNetworkPublisher: Publisher {
    typealias Output = Data
    typealias Failure = Error

    let fileURL: URL

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = FileSubscription(fileURL: fileURL, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

/// Candidates should not modify this class
private class FileSubscription<S: Subscriber>: Subscription where S.Input == Data, S.Failure == Error {
    private let fileURL: URL
    private var subscriber: S?

    init(fileURL: URL, subscriber: S) {
        self.fileURL = fileURL
        self.subscriber = subscriber
    }

    func request(_ demand: Subscribers.Demand) {
        if demand > 0 {
            do {
                let data = try Data(contentsOf: fileURL)
                _ = subscriber?.receive(data)
                subscriber?.receive(completion: .finished)
            } catch {
                subscriber?.receive(completion: .failure(error))
            }
        }
    }

    func cancel() {
        subscriber = nil
    }
}

