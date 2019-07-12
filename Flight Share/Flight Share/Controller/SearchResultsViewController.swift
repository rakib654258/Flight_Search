//
//  SearchResultsViewController.swift
//  Flight Share
//
//  Created by macOS Mojave on 12/7/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
}
