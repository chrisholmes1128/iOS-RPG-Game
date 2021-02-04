//
//  rpgGameApp.swift
//  rpgGame
//
//  Created by Chris Holmes on 2/4/21.
//

import SwiftUI

@main
struct rpgGameApp: App {
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup{
            MotherView().environmentObject(viewRouter)
        }
    }
}
