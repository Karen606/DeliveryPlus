//
//  TrackingTableViewCell.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 11.12.24.
//

import UIKit

class TrackingTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.borderColor = UIColor.black.cgColor
        bgView.layer.borderWidth = 1.5
        orderLabel.font = .regular(size: 19)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(order: OrderModel) {
        orderLabel.text = "Order \(order.orderNumber ?? "") - \(OrderStatus.allCases[order.status].rawValue)"
    }
    
}
