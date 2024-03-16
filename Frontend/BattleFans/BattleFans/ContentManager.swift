//
//  ContentManager.swift
//  BattleNouns
//
//  Created by Alok Sahay on 16.03.2024.
//

import Foundation
import UIKit

class ContentManager {
    
    static let nounsApi = "https://noun-api.com/beta/pfp?"
    
    
    static let arsenalNounAsset = URL(string: "\(ContentManager.nounsApi)" + "head=46&glasses=11&body=5&accessory=53")
    static let lgdNounAsset = URL(string: "\(ContentManager.nounsApi)" + "head=46&glasses=6&body=3&accessory=43")
    static let milanNounAsset = URL(string: "\(ContentManager.nounsApi)" + "head=46&glasses=3&body=8&accessory=13")
    static let barcelonaNounAsset = URL(string: "\(ContentManager.nounsApi)" + "head=46&glasses=2&body=9&accessory=16")
    static let refereeNounAsset = URL(string: "\(ContentManager.nounsApi)" + "head=46&glasses=11&body=26&accessory=58&theme=nounsinblack")
    
    static func fetchAsset(assetURL: URL?, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = assetURL else {
            completion(nil, NSError(domain: "InvalidURL", code: 404, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "DataError", code: 404, userInfo: nil))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(image, nil)
            }
        }.resume()
    }
    
    
    
}
