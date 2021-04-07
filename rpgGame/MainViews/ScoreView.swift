//
//  ScoreView.swift
//  TestTutorMe
//
//  Created by Chris Holmes on 2/3/21.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        
        ZStack {
            let levels = getLevels()
            
            BackgroundView()
            VStack{
                
                Text("High Scores")
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                
                HStack(spacing: 20){
                    ForEach(levels.indices) { i in
                        VStack{
                            let scores = getScores(key: levels[i])
                            //title
                            Text(levels[i])
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                            //scores
                            ForEach(scores.indices) {i in
                                Text("\(i+1) | \(scores[i])")
                                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                        }
                    }
                }
                
                
                Button(action: {
                    withAnimation {
                        viewRouter.currentPage = .homeScreenView
                    }
                }) {
                    Text("Home Screen")
                }.padding()
            }
        }
    }
}

extension ScoreView {
    func getLevels() -> [String] {
        let levels = ["Tutorial", "Level1", "Level2"]
        return levels
    }
    
    func getScores(key: String) -> [Int] {
        let data = UserDefaults.standard
        var scores:[Int] = data.array(forKey: key) as? [Int] ?? []
        scores.sort(by: >)
        return scores
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView().environmentObject(ViewRouter())
    }
}
