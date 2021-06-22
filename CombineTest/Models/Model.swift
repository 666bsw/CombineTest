//
//  Model.swift
//  CombineTest
//
//  Created by Bezdenezhnykh Sergey on 21.06.2021.
//

import Foundation

struct Order: Identifiable {
    enum State {
        case pending, inProgress, fulfilled, rejected
    }

    let id: UUID
    let lastModified: Date
    let seat: (UInt, Character)
    let state: State
    let price: (Decimal, String)
    let items: [String]
}

extension Order.State: CaseIterable {
    var title : String {
        switch self {
        case .pending:      return "pending"
        case .inProgress:   return "inProgress"
        case .fulfilled:    return "fulfilled"
        case .rejected:     return "rejected"
        }
    }
}


