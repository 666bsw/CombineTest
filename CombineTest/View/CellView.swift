//
//  CellView.swift
//  CombineTest
//
//  Created by Bezdenezhnykh Sergey on 22.06.2021.
//

import SwiftUI

struct CellView: View {
    var order: Order
    
    var body: some View {
        VStack{
            HStack {Text("Id:"); Spacer(); Text(order.id.uuidString).font(.caption2) }
            HStack {Text("Last Modified:"); Spacer(); Text(order.lastModified.asString()) }
            HStack {Text("Seat:"); Spacer(); Text(String(order.seat.0)); Text(",\(String(order.seat.1))") }
            HStack {Text("State:"); Spacer(); Text(order.state.title) }
            HStack {Text("Price:"); Spacer(); Text(order.price.0.formattedString); Text(" \(order.price.1)") }
            HStack {Text("Items:")
                Spacer()
                ForEach(order.items, id: \.self) { item in
                    Text(" \(item)")
                }
            }
        }
    }
}

