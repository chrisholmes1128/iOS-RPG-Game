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
            case .Tutorial1View:
                Tutorial1View().transition(.scale)
            case .Tutorial2View:
                Tutorial2View().transition(.scale)
            case .Tutorial3View:
                Tutorial3View().transition(.scale)
            case .ReadyToPlayView:
                ReadyToPlayView().transition(.scale)
            case .GameView:
                GameView(started: Binding.constant(true)).transition(.scale)
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
