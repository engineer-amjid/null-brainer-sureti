//
//  SplashViewController.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 19/04/2022.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var splashBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var splashBarBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        splashBarTopConstraint.constant = -70
        splashBarBottomConstraint.constant = 68
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if let vc = LoginViewController.instantiate() {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

}
