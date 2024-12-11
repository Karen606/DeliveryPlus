//
//  TrackingViewModel.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 11.12.24.
//

import Foundation

class TrackingViewModel {
    static let shared = TrackingViewModel()
    private var data: [OrderModel] = []
    @Published var orders: [OrderModel] = []
    private var search: String?
    var selectedFilter: Int? = 0
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchOrders { [weak self] orders, _ in
            guard let self = self else { return }
            self.data = orders
            self.filter()
        }
    }
    
    func filter() {
        let trimmedSearch = search?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        orders = data.filter { order in
            let matchesType = (selectedFilter ?? 0) == 0 || order.status == selectedFilter
            let matchesSearch = trimmedSearch == nil || trimmedSearch!.isEmpty || (order.address?.lowercased().contains(trimmedSearch!)) ?? false
            return matchesType && matchesSearch
        }
    }
    
    func search(by value: String?) {
        self.search = value
        filter()
    }
    
    func chooseFilter(by index: Int?) {
        self.selectedFilter = index
        filter()
    }
    
    func clear() {
        data = []
        orders = []
        search = nil
        selectedFilter = 0
    }
}
