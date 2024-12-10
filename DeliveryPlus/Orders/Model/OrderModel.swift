//
//  OrderModel.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import Foundation

struct OrderModel {
    var id: UUID
    var address: String?
    var recipientsName: String?
    var product: String?
    var deliveryDate: Date?
    var status: Int = 1
    var orderNumber: String?
}
