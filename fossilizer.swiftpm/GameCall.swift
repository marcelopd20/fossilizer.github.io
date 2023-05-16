//
//  GameCall.swift
//  fossilizer
//
//  Created by Marcelo Pastana Duarte on 12/04/23.
//

import Combine
import SwiftUI
import SpriteKit

struct GameCall: View {
    
    @ObservedObject var gameScene: GameController
    @State var showText: Bool = true
    @State var playAgain: Bool = false
    var body: some View {
        if gameScene.changeView {
            ZStack{
                Image("bg_rock")
                    .resizable()
                    .frame(width: 553, height: 1200)
                    .offset(.zero)
                
                ForEach(gameScene.ecdysis) { ecdsysData in
                    if ecdsysData.clicks >= 4 {
                        Image("trilobite_fossil")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * (80/gameScene.size.width),
                                   height: UIScreen.main.bounds.height * (120/gameScene.size.height))
                            .rotationEffect(Angle(radians: -ecdsysData.rot))
                            .offset(x: UIScreen.main.bounds.width * ((ecdsysData.x - gameScene.size.width/2.0) / gameScene.size.width) ,
                                    y:UIScreen.main.bounds.height * ((gameScene.size.height/2.0 - ecdsysData.y) / gameScene.size.height))
                    }
                }
                if showText {
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width - 50),height: (UIScreen.main.bounds.height - 600), alignment: .center)
                        .border(.black, width: 8)
                        .cornerRadius(20)
                        .offset(CGSize(width: 0, height: -125))
                        .foregroundColor(.init(white: 0.8, opacity: 0.8))
                        .opacity(1)
                    VStack(spacing: 10){
                        Text("The sea floor has changed after millions of years, and that sand became a rock.\nLook how the ecdysis were preserverd and became fossilized!")
                            .frame(width: (UIScreen.main.bounds.width - 70),height: (UIScreen.main.bounds.height - 500))
                            .multilineTextAlignment(.center)
                            .offset(CGSize(width: 0, height: -80))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                        
                        Button(action:{self.playAgain = true}){
                            Image("play_again_button").resizable().frame(width:296,height:72, alignment: .center)
                        }
                    }
                }
                Toggle("", isOn: $showText).frame(width:200).offset(x: 50,y: -350).contrast(200)
            }.ignoresSafeArea(.all).aspectRatio(contentMode: .fit)
            NavigationLink(destination: StoryTelling().navigationBarBackButtonHidden(true), isActive: $playAgain,label: {EmptyView()})
        } else {
            VStack {
                //if let gameScene {
                    SpriteView(scene: gameScene).ignoresSafeArea()
                //}
            }
        }
    }
}
