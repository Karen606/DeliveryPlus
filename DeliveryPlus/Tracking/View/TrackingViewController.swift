//
//  TrackingViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 11.12.24.
//

import UIKit
import DropDown
import Combine

class TrackingViewController: UIViewController {

    @IBOutlet weak var searchTextField: PaddingTextField!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var selectedFilterView: UIView!
    @IBOutlet weak var selectedFilterLabel: UILabel!
    @IBOutlet weak var ordersTableView: UITableView!
    private let dropDown = DropDown()
    private let viewModel = TrackingViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = 200
        self.dropDown.bottomOffset = CGPoint(x: self.filterView.frame.minX, y: self.filterView.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationBackButton()
        searchTextField.addShadow()
        searchTextField.setupLeftViewIcon(.searchIcon)
        filterView.layer.cornerRadius = 16
        filterView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        filterView.layer.borderWidth = 1
        selectedFilterView.layer.cornerRadius = 16
        selectedFilterView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        selectedFilterView.layer.borderWidth = 1
        let data: [String] = OrderStatus.allCases.map { $0.rawValue }
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = view
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        DropDown.appearance().selectionBackgroundColor = .clear
        dropDown.addShadow()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.chooseFilter(by: index)
        }
        ordersTableView.register(UINib(nibName: "TrackingTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackingTableViewCell")
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        searchTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$orders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orders in
                guard let self = self else { return }
                if let filter = self.viewModel.selectedFilter {
                    self.selectedFilterLabel.text = OrderStatus.allCases[filter].rawValue
                    self.selectedFilterView.isHidden = false
                } else {
                    self.selectedFilterView.isHidden = true
                }
                self.ordersTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func chooseFilter(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func removeSelectedFilter(_ sender: UIButton) {
        viewModel.chooseFilter(by: nil)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TrackingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackingTableViewCell", for: indexPath) as! TrackingTableViewCell
        cell.configure(order: viewModel.orders[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
}

extension TrackingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.search(by: textField.text)
    }
}
