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
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setToRecipients(["surbekbabun@outlook.com"])
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(
//                title: "Mail Not Available",
//                message: "Please configure a Mail account in your settings.",
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
//        let privacyVC = PrivacyViewController()
//        self.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
//        let appID = "6738995312"
//        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                print("Unable to open App Store URL")
//            }
//        }
    }

    @IBAction func clickedClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
