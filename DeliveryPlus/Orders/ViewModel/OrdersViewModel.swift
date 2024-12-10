//
//  OrdersViewModel.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import Foundation

class OrdersViewModel {
    static let shared = OrdersViewModel()
    private var data: [OrderModel] = []
    @Published var orders: [OrderModel] = []
    private var search: String?
    var selectedFilter = 0
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchOrders { [weak self] orders, _ in
            guard let self = self else { return }
            self.data = orders
            filter()
        }
    }
    
    func chooseFilter(by filter: Int) {
        self.selectedFilter = filter
        self.filter()
    }
    
    func search(by value: String?) {
        search = value
        self.filter()
    }
    
    private func filter() {
        let trimmedSearch = search?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        orders = data.filter { order in
            var matchesType = false
            switch selectedFilter {
            case 0:
                matchesType = true
            case 1:
                matchesType = (1...2).contains(order.status)
            case 2:
                matchesType = order.status == 2
            default:
                break
            }
            let matchesSearch = trimmedSearch == nil || trimmedSearch!.isEmpty || (order.address?.lowercased().contains(trimmedSearch!)) ?? false
            return matchesType && matchesSearch
        }
    }
    
    func clear() {
        data = []
        orders = []
        search = nil
        selectedFilter = 0
    }
}
