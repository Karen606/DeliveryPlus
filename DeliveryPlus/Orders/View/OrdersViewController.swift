//
//  OrdersViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import UIKit
import Combine

class OrdersViewController: UIViewController {

    @IBOutlet weak var searchTextField: PaddingTextField!
    @IBOutlet var filterButtons: [TabButton]!
    @IBOutlet weak var ordersTableView: UITableView!
    private let viewModel = OrdersViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNavigationMenuButton()
        searchTextField.addShadow()
        searchTextField.setupLeftViewIcon(.searchIcon)
        ordersTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderTableViewCell")
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let self = self else { return }
                self.filterButtons[self.viewModel.selectedFilter].isSelected = true
                self.ordersTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func selectFilter(_ sender: TabButton) {
        filterButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        viewModel.chooseFilter(by: sender.tag)
    }
    
    @IBAction func clickedCreate(_ sender: UIButton) {
        let orderFormVC = OrderFormViewController(nibName: "OrderFormViewController", bundle: nil)
        orderFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(orderFormVC, animated: true)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.configure(order: viewModel.orders[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        23
    }
}

extension OrdersViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.search(by: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

enum OrderFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}
