//
//  ContentView.swift
//  CombineTest
//
//  Created by Bezdenezhnykh Sergey on 22.06.2021.
//
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.orders, id: \.id) { order in
                    CellView(order: order)
                }
                .onDelete(perform: removeRows)
                .font(.callout)
            }
            .navigationTitle("Orders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addOrder()
                    } label: {
                        Text("Add Order")
                    }
                }
            }
        }
        .navigationBarColor(backgroundColor: UIColor.systemBlue, tintColor: .white)
    }
    private func removeRows(at offset: IndexSet) {
        //FIXME: - если пишется, остановить запись!!!
        var orderDelete = [Order] ()
        offset.forEach { (index) in
            let order = viewModel.orders[index]
            orderDelete.append(order)
        }
        viewModel.deleteOrder(orders: orderDelete)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
