//
//  OrderDetailsViewModel.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import Foundation

class OrderDetailsViewModel {
    static let shared = OrderDetailsViewModel()
    @Published var order = OrderModel(id: UUID())
    var newStatus: Int = 1
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.changeOrderStatus(orderId: order.id, newStatus: newStatus, completion: completion)
    }
    
    func clear() {
        order = OrderModel(id: UUID())
        newStatus = 1
    }
}
