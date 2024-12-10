//
//  OrderFormViewModel.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import Foundation

class OrderFormViewModel {
    static let shared = OrderFormViewModel()
    @Published var order = OrderModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveOrder(orderModel: order, completion: completion)
    }
    
    func clear() {
        order = OrderModel(id: UUID())
    }
}
