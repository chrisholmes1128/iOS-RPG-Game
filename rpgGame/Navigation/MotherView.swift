//
//  MotherView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 2/3/21.
//
import SwiftUI

struct MotherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        switch viewRouter.currentPage {
            case .homeScreenView:
                ContentView()
            case .optionsView:
                OptionsView().transition(.scale)
            case .highScoresView:
                ScoreView().transition(.scale)
            case .gameCenterView:
                GameCenterView().transition(.scale)
            case .LevelsView:
                LevelsView().transition(.scale)
            case .GameView:
                GameView().transition(.scale)
            case .PauseMenuView:
                PauseMenuView(pauseMenuShowing: Binding.constant(true)).transition(.scale)
        }
    }
}



struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
