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
            case .page1:
                ContentView()
            case .page2:
                OptionsView().transition(.scale)
            case .page3:
                ScoreView().transition(.scale)
            case .page4:
                GameCenterView().transition(.scale)
            case .LevelsView:
                LevelsView().transition(.scale)
            case .GameView:
                GameView().transition(.scale)
        }
    }
}



struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
