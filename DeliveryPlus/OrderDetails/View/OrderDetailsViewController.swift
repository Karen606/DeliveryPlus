//
//  OrderDetailsViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import UIKit
import DropDown
import Combine

class OrderDetailsViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private let dropDown = DropDown()
    private let viewModel = OrderDetailsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = self.statusButton.bounds.width
        self.dropDown.bottomOffset = CGPoint(x: self.statusButton.frame.minX, y: self.statusButton.frame.maxY + 2)
    }
    
    func setupUI() {
        self.view.backgroundColor = .clear
        orderNumberLabel.font = .medium(size: 17)
        currentStatusLabel.font = .regular(size: 18)
        statusButton.titleLabel?.font = .regular(size: 18)
        cancelButton.titleLabel?.font = .semibold(size: 16)
        cancelButton.layer.borderColor = UIColor.baseGreen.cgColor
        cancelButton.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.5
        var data: [String] = OrderStatus.allCases.map { $0.rawValue }
        data.removeFirst()
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = contentView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        dropDown.addShadow()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            viewModel.newStatus = index + 1
            self.statusButton.setTitle("New status: \(OrderStatus.allCases[viewModel.newStatus].rawValue)", for: .normal)
        }
    }
    
    func subscribe() {
        viewModel.$order
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self = self else { return }
                self.viewModel.newStatus = order.status
                self.orderNumberLabel.text = "Order \(order.orderNumber ?? "")"
                self.currentStatusLabel.text = "Current status: \(OrderStatus.allCases[order.status].rawValue)"
                self.statusButton.setTitle("New status: \(OrderStatus.allCases[viewModel.newStatus].rawValue)", for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func chooseStatus(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
