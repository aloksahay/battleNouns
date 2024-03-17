//
//  ConfettiView.swift
//  BattleFans
//
//  Created by Alok Sahay on 17.03.2024.
//

import UIKit

class ConfettiView: UIView {
    var emitter: CAEmitterLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfetti()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConfetti()
    }
    
    func setupConfetti() {
        emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: self.frame.width / 2, y: 0)
        emitter.emitterSize = CGSize(width: self.frame.width, height: 1)
        let colors: [UIColor] = [.red, .green, .blue, .yellow, .purple, .orange]
        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = 300
            cell.velocityRange = 100
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 3.5
            cell.spinRange = 1.0
            cell.color = color.cgColor
            cell.contents = UIImage(named: "confetti")?.cgImage
            cell.scaleRange = 0.5
            cell.scale = 0.1
            return cell
        }
        emitter.emitterCells = cells
        self.layer.addSublayer(emitter)
    }
    
    func startConfetti() {
        emitter.birthRate = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 5 seconds delay
            self.stopConfetti()
        }
    }
    
    func stopConfetti() {
        emitter.birthRate = 0
    }
}

