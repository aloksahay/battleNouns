//
//  ViewController.swift
//  BattleFans
//
//  Created by Alok Sahay on 16.03.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPlayerSelect()
    }
    
    func loadPlayerSelect() {
        performSegue(withIdentifier: "ShowPlayers", sender: nil)
    }
    
    
    
}

