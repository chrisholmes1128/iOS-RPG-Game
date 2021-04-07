//
//  Tutorial1.swift
//  rpgGame
//
//  Created by Chris Holmes on 3/31/21.
//

import SwiftUI

struct Tutorial2View: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                Spacer()
                
                Text("Tutorial: Part 2")
                    .underline()
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .cornerRadius(8)
    
                Text("To Run, place your finger on the screen and move the toggle that displays")
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 1000, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                
                walkAnimation()
                
                Spacer()
                
                HStack {
                    Text("BACK")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .Tutorial1View
                        }
                    Text("NEXT")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 30, alignment: .center)
                        .transition(.move(edge: .leading))
                        .padding()
                        .border(Color.white, width: 3)
                        .cornerRadius(8)
                        .onTapGesture {
                            viewRouter.currentPage = .Tutorial3View
                        }
                }
                
                Spacer()
            }
        }
    }
}

var walkImages : [UIImage]! = [UIImage(named: "Warrior_Run_1")!, UIImage(named: "Warrior_Run_2")!, UIImage(named: "Warrior_Run_3")!, UIImage(named: "Warrior_Run_4")!, UIImage(named: "Warrior_Run_5")!, UIImage(named: "Warrior_Run_6")!, UIImage(named: "Warrior_Run_7")!, UIImage(named: "Warrior_Run_8")! ]

let animatedWalkImage = UIImage.animatedImage(with: walkImages, duration: 1.2)

struct walkAnimation: UIViewRepresentable {

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
        let someImage = UIImageView(frame: CGRect(x: 520, y: 100, width: 360, height: 300))
        someImage.clipsToBounds = true
        someImage.layer.cornerRadius = 20
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFill
        someImage.image = animatedWalkImage
        someView.addSubview(someImage)
        return someView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<walkAnimation>) {

    }
}

struct Tutorial2View_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial2View()
    }
}


