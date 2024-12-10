//
//  ViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 10.12.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(OrdersViewController.self)
    }


}

