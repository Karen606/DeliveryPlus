//
//  OrderTableViewCell.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.borderWidth = 1.5
        bgView.layer.borderColor = UIColor.black.cgColor
        orderLabel.font = .regular(size: 19)
        addressLabel.font = .regular(size: 19)
        statusLabel.font = .regular(size: 19)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(order: OrderModel) {
        orderLabel.text = "Order \(order.orderNumber ?? "")"
        addressLabel.text = "Address: \(order.address ?? "")"
        statusLabel.text = "Status: \(OrderStatus.allCases[order.status].rawValue)"
    }
    
}
