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
    
    @IBOutlet weak var ballView: UIImageView!
    @IBOutlet weak var fieldView: UIView!
    
    var currentStringIndex: Int = 0
    var textTimer: Timer?
    var message: String = ""

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var conversationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ballView.alpha = 0.0
        dialogView.alpha = 0.0
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
        resetFootBall()
    }
    
    func resetFootBall() {
        ballView.alpha = 1.0
        ballView.center = CGPoint(x: fieldView.bounds.width/2, y: fieldView.bounds.height/2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadFirstLevel()
        }
    }
    
    func scoreGoal() {
        UIView.animate(withDuration: 0.5) {
            self.ballView.center = CGPoint(x: self.fieldView.bounds.width - 20, y: self.fieldView.bounds.height/2)
        }
    }
 
    func loadFirstLevel() {
        self.showConversation(text: "Game on!")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 5 seconds delay
            self.showConversation(text: "Find the first clue behind the unicorn")
        }
    }
    
    
    func showConversation(text: String) {
        
        message = text
        
        currentStringIndex = 0
        conversationLabel.text = ""
        textTimer?.invalidate()
        textTimer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }
    
    @objc func updateText() {
        
        dialogView.alpha = message.isEmpty ? 0.0 : 0.8
        
        guard currentStringIndex < message.count else {
            textTimer?.invalidate()
            return
        }
        
        let index = message.index(message.startIndex, offsetBy: currentStringIndex)
        conversationLabel.text?.append(message[index])
        currentStringIndex += 1
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
