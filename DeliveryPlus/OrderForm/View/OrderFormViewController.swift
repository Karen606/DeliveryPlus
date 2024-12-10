//
//  OrderFormViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import UIKit
import Combine

class OrderFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var addressTextField: BaseTextField!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var productTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    private let datePicker = UIDatePicker()
    private let viewModel = OrderFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        titleLabels.forEach({ $0.font = .regular(size: 19) })
        cancelButton.titleLabel?.font = .semibold(size: 16)
        cancelButton.layer.borderColor = UIColor.baseGreen.cgColor
        cancelButton.layer.borderWidth = 1
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        addressTextField.delegate = self
        nameTextField.delegate = self
        productTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$order
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self = self else { return }
                self.saveButton.isEnabled = (order.address.checkValidation() && order.recipientsName.checkValidation() && order.product.checkValidation() && order.deliveryDate != nil)
            }
            .store(in: &cancellables)
    }
    
    @objc func datePickerValueChanged() {
        viewModel.order.deliveryDate = datePicker.date
        dateTextField.text = datePicker.date.toString(format: "dd/MM/yy HH:mm")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension OrderFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case addressTextField:
            viewModel.order.address = textField.text
        case nameTextField:
            viewModel.order.recipientsName = textField.text
        case productTextField:
            viewModel.order.product = textField.text
        default:
            break
        }
    }
}

enum OrderStatus: String, CaseIterable {
    case all = "All"
    case awaitingsShipment = "Awaitings shipment"
    case onTheWay = "On the Way"
    case delivered = "Delivered"
    case canclelled = "Canclelled"
}
