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
            Spacer()
            VStack {
                VStack {
                    Text("High Scores")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                }
                
                HStack(alignment: .top, spacing: 200) {
                    //Tutorial Scores
                    VStack{
                        let scores = getScores(key: levels[0])
                        VStack(){
                                
                                Text("Tutorial")
                                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 50, alignment: .center)
                                    .border(Color.white, width: 3)
                                    .padding()
                                        
                                VStack {
                                    ForEach(scores.indices) {i in
                                        Text("\(i+1).    \(scores[i])")
                                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                                            .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    //Level 1 Scores
                    VStack{
                        let scores = getScores(key: levels[1])
                            VStack(){
                                
                                Text("Level 1")
                                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 50, alignment: .center)
                                    .border(Color.white, width: 3)
                                    .padding()
                                
                                VStack {
                                    ForEach(scores.indices) {i in
                                        Text("\(i+1).    \(scores[i])")
                                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding()
                                }
                            }
                        }
                    }
                    //Level 2 Scores
                    VStack{
                        let scores = getScores(key: levels[2])
                        VStack(){
                                Text("Level 2")
                                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 50, alignment: .center)
                                    .border(Color.white, width: 3)
                                    .padding()
                            
                                VStack {
                                    ForEach(scores.indices) {i in
                                        Text("\(i+1).    \(scores[i])")
                                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding()
                                }
                            }
                        }
                    }
                    
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                VStack{
                    Text("BACK")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .homeScreenView
                        }
                }.padding(.bottom, 20)
                
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
