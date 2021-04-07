//
//  Tutorial1.swift
//  rpgGame
//
//  Created by Chris Holmes on 3/31/21.
//

import SwiftUI

struct Tutorial1View: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                Spacer()
                
                Text("Tutorial: Part 1")
                    .underline()
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .padding()
                    .cornerRadius(8)
    
                
                Text("To Attack an Enemy.. Just Tap the Screen!")
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 1000, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                
                attackAnimation()
                
                Text("Tip: Remember to get in range of enemy before attacking ")
                    .font(.system(size: 25, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 1000, height: 30, alignment: .center)
                    .transition(.move(edge: .leading))
                    .cornerRadius(8)
                    .padding(.bottom, 30)
                
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
                            viewRouter.currentPage = .LevelsView
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
                            viewRouter.currentPage = .Tutorial2View
                        }
                }
                
                Spacer()
            }
        }
    }
}

var attackImages : [UIImage]! = [UIImage(named: "Warrior_Attack_1")!, UIImage(named: "Warrior_Attack_2")!, UIImage(named: "Warrior_Attack_3")!, UIImage(named: "Warrior_Attack_4")!, UIImage(named: "Warrior_Attack_5")!, UIImage(named: "Warrior_Attack_6")!, UIImage(named: "Warrior_Attack_7")!, UIImage(named: "Warrior_Attack_8")! , UIImage(named: "Warrior_Attack_9")!, UIImage(named: "Warrior_Attack_10")!, UIImage(named: "Warrior_Attack_11")!, UIImage(named: "Warrior_Attack_12")!]


let animatedAttackImage = UIImage.animatedImage(with: attackImages, duration: 1.5)

struct attackAnimation: UIViewRepresentable {

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 700))
        let someImage = UIImageView(frame: CGRect(x: 520, y: 100, width: 360, height: 300))
        someImage.clipsToBounds = true
        someImage.layer.cornerRadius = 20
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFill
        someImage.image = animatedAttackImage
        someView.addSubview(someImage)
        return someView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<attackAnimation>) {

    }
}
struct Tutorial1View_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial1View()
    }
}

