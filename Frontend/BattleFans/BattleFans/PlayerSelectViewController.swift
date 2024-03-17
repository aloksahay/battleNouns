//
//  PlayerSelectViewController.swift
//  BattleFans
//
//  Created by Alok Sahay on 16.03.2024.
//

import Foundation
import UIKit

protocol ModalDelegate: AnyObject {
    func modalDidDismiss()
}

class PlayerSelectViewController: UIViewController {

    @IBOutlet weak var arsenalButton: UIButton!
    @IBOutlet weak var psgButton: UIButton!
    @IBOutlet weak var acmButton: UIButton!
    @IBOutlet weak var fcbButton: UIButton!
            
    @IBOutlet weak var messageLabel: UILabel!
    
    weak var delegate: ModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func loadPlayerSelect() {        
        
        for button in [arsenalButton, psgButton, acmButton, fcbButton] {
            button?.backgroundColor = .white
            button?.isEnabled = true
        }
        
        arsenalButton.setImage(.pfp1, for: .normal)
        
        psgButton.setImage(.pfp2, for: .normal)
        
        acmButton.setImage(.pfp3, for: .normal)
        
        fcbButton.setImage(.pfp4, for: .normal)
        
        messageLabel.text = "Pick your Avatar"
    }
    
    @IBAction func button1Pressed(_ sender: Any) {
        
        if ContentManager.teamSelect < 0 {
            ContentManager.teamSelect = 1
            loadPlayerSelect()
        } else {
            ContentManager.pfpSelect = 1
            dismissModal()
        }
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        
        if ContentManager.teamSelect < 0 {
            ContentManager.teamSelect = 2
            loadPlayerSelect()
        } else {
            ContentManager.pfpSelect = 2
            dismissModal()
        }
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        
        if ContentManager.teamSelect < 0 {
            ContentManager.teamSelect = 3
            loadPlayerSelect()
        } else {
            ContentManager.pfpSelect = 3
            dismissModal()
        }
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        
        if ContentManager.teamSelect < 0 {
            ContentManager.teamSelect = 4
            loadPlayerSelect()
        } else {
            ContentManager.pfpSelect = 4
            dismissModal()
        }
    }
    
    func dismissModal() {
            self.dismiss(animated: true) { [weak self] in
                self?.delegate?.modalDidDismiss()
            }
        }
}
