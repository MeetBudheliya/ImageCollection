//
//  ThirdViewController.swift
//  ImageCollection
//
//  Created by Meet's MAC on 30/08/22.
//

import UIKit
import InteractiveSideMenu

class ThirdViewController: UIViewController, SideMenuItemContent {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // Show side menu on menu button click
    @IBAction func openMenu(_ sender: UIButton) {
        showSideMenu()
    }

}
