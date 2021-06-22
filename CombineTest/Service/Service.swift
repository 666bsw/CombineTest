//
//  Service.swift
//  CombineTest
//
//  Created by Bezdenezhnykh Sergey on 21.06.2021.
//

import Foundation
import Combine

protocol Service where Self.T.Element == Order {
    associatedtype T: RandomAccessCollection
    init(added: AnyPublisher<Order, Never>, removed: AnyPublisher<Order, Never>)
    var output: AnyPublisher<T, Never> { get }
}

final class OrderService: Service {
    
    typealias T = [Order]
    
    var output: AnyPublisher<T, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private var orders: T = [] {
        didSet { subject.send(orders) }
    }
    
    private let subject = PassthroughSubject<T, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(added: AnyPublisher<Order, Never>, removed: AnyPublisher<Order, Never>) {
        bind(added, removed)
    }
    
    private func bind(_ added: AnyPublisher<Order, Never>, _ removed: AnyPublisher<Order, Never>) {
        added
            .sink { [weak self] order in
                self?.orders.append(order)
            }
            .store(in: &subscriptions)
        removed
            .sink { [weak self] order in
                self?.orders.removeAll { $0.id == order.id}
            }
            .store(in: &subscriptions)
    }
}
