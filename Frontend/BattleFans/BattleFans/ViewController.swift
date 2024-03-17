//
//  ViewController.swift
//  BattleFans
//
//  Created by Alok Sahay on 16.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftTeamImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rightTeamImage: UIImageView!
    @IBOutlet weak var leftPlayerImage: UIImageView!
    @IBOutlet weak var rightPlayerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPlayerSelect()
    }
    
    func loadPlayerSelect() {
        if ContentManager.teamSelect < 0 && ContentManager.pfpSelect < 0 {
            performSegue(withIdentifier: "ShowPlayers", sender: nil)
        }
    }
    
    func loadTeams() {
        leftTeamImage.image = ContentManager.teamImage(teamNumber: ContentManager.teamSelect)
        rightTeamImage.image = .fcb
        scoreLabel.text = "0-0"
        rightPlayerImage.image = .pfpRef
        leftPlayerImage.image = ContentManager.playerImage(teamNumber: ContentManager.pfpSelect)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayers" {
            let modalViewController = segue.destination as? PlayerSelectViewController
            modalViewController?.delegate = self
        }
    }
    
}

extension ViewController: ModalDelegate {
    func modalDidDismiss() {        
        loadTeams()
    }
}
