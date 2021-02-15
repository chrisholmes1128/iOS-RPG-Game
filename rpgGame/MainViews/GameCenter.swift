//
//  GameCenter.swift
//  rpgGame
//
//  Created by Chris Holmes on 2/8/21.
//

import SwiftUI
import UIKit
import GameKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
    }
    
    let localPlayer = GKLocalPlayer.local
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            if vc != nil {
                self.present(vc!, animated: true, completion: nil)
            } else {
                print("Login was interrupted.")
            }
            if #available(iOS 14.0, *) {
                GKAccessPoint.shared.location = .bottomLeading
                GKAccessPoint.shared.showHighlights = true
                GKAccessPoint.shared.isActive = self.localPlayer.isAuthenticated
            }
        }
    }
}


struct GameCenterManager: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<GameCenterManager>) -> ViewController {
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<GameCenterManager>) {
    }
    
}
