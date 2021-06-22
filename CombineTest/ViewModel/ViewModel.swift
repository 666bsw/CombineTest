//
//  ViewModel.swift
//  CombineTest
//
//  Created by Bezdenezhnykh Sergey on 21.06.2021.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    
    @Published var orders: [Order] = []
    private var service: OrderService
    private var subscriptions = Set<AnyCancellable>()
    
    typealias SortOrder = (Order, Order) -> Bool
    
    
    var added = PassthroughSubject<Order, Never>()
    var removed = PassthroughSubject<Order, Never>()
    
    init() {
        self.service = OrderService(added: added.eraseToAnyPublisher(),
                                    removed: removed.eraseToAnyPublisher())
        service.output
            .sink { [weak self] orders in
                self?.orders = self?.sortArray(orders) ?? []
            }
            .store(in: &subscriptions)
        addOrder()
    }
    
    func addOrder() {
        let order = Order(id: UUID(),
                          lastModified: generateRandomDate(daysBack: 30) ??  Date(),
                          seat: (UInt(randomInt(from: 1, to: 99)), Character(randomString(of: 1))),
                          state: Order.State.allCases.randomElement() ?? .fulfilled ,
                          price: (Decimal(Double.random(in: 1...100)), randomString(of: 3)),
                          items: [randomWord(), randomWord()])
        added.send(order)
    }
    
    func deleteOrder(orders: [Order]) {
        guard let order = orders.first else {return}
        removed.send(order)
    }
}

extension ViewModel {
    private func sortArray(_ orders: [Order]) -> [Order] {
        print("SORT")
        let arr1 = orders.filter({$0.state == .pending || $0.state == .inProgress})
        var arr2 = orders.filter({$0.state == .fulfilled || $0.state == .rejected})
        var outOrders = arr1.sorted {$0.lastModified > $1.lastModified }
        
        arr2 = arr2 .sorted { (lhs, rhs) in
            let predicates: [SortOrder] = [
                {$0.seat.0 > $1.seat.0},
                {$0.seat.1 > $1.seat.1},
                {$0.lastModified > $1.lastModified}
            ]
            for predicate in predicates {
                if !predicate(lhs, rhs) && !predicate(rhs, lhs) {
                    continue
                }
                return predicate(lhs, rhs)
            }
            return false
        }
        outOrders.append(contentsOf: arr2)
        return outOrders
    }
}

extension ViewModel {
    
    private func randomWord() -> String {
        let length = randomInt(from: 5, to: 9)
        return randomString(of: length)
    }
    
    private func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s.capitalized
    }
    
    private func randomInt(from: Int, to: Int) -> Int {
        let range = UInt32(to - from)
        let rndInt = Int(arc4random_uniform(range + 1)) + from
        return rndInt
    }
    
    private func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }
}
