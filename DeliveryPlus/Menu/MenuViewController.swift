//
//  MenuViewController.swift
//  DeliveryPlus
//
//  Created by Karen Khachatryan on 11.12.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var sectionButtons: [UIButton]!
    var completion: ((Int) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 30
        sectionButtons.forEach({ $0.titleLabel?.font = .medium(size: 24) })
    }
    
    @IBAction func clickedCreateOrder(_ sender: UIButton) {
        self.completion?(0)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedTrackingOrders(_ sender: UIButton) {
        self.completion?(1)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
        completion?(2)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
        completion?(3)
        self.dismiss(animated: true)
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        completion?(4)
        self.dismiss(animated: true)
    }

    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
