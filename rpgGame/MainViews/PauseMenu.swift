//
//  PauseMenu.swift
//  rpgGame
//
//  Created by Chris Holmes on 2/15/21.
//

import Combine
import SwiftUI
import UIKit

struct PauseMenuView: View {
    
    @State private var titleShowing = false
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var pauseMenuShowing: Bool
    
    var body: some View {
        ZStack {
            VStack {
                BackgroundView()
            }
            if pauseMenuShowing {
                VStack{
                    Spacer()
                    Text("RESUME")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                pauseMenuShowing.toggle()
                                viewRouter.currentPage = .GameView
                            }
                        }
                    Text("QUIT")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .homeScreenView
                        }
                    Spacer()
                    
                }.onAppear {
                    withAnimation{
                        titleShowing.toggle()
                    }
                }
            }
        }
    }
}

struct PauseMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PauseMenuView(pauseMenuShowing: Binding.constant(true)).environmentObject(ViewRouter())
    }
}
