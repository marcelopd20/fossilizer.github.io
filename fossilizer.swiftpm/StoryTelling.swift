//
//  StoryTelling.swift
//  fossilizer
//
//  Created by Marcelo Pastana Duarte on 11/04/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct StoryTelling: View {
    @State var isStarted = false
    @State var startStory = false
    @State var uiX = UIScreen.main.bounds.width
    @State var uiY = UIScreen.main.bounds.height
    @State var startTalking = false
    @State private var position = CGSize(width: 0, height: 0)
    private var history = ["Hi, I'm a trilobite!\n\n The trilobites are arthropods, our lineage is very close of crabs and spiders. You, humans, have more than 22 thousands species of us described.\n\n You won't see me in the sea nowadays, because I lived from the Cambrian to the Permian. \n\nWe were extincted about 250 milions of years ago.\n\nMy species is one of the most famous beyond paleontologists, and I will tell you why...","We're the most abundant fossil in the geological register!!!\n\nTo understand  why, you need to understand how the fossils are formed.\n\nThe science that studies the fossil's formation process is Taphonomy, a branch of Archeology and Paleontology.\n\nOur fossilization became a success, and I will tell you how...","To became a fossil you need to be in a special condition during the rock's formation process that favorizes fossilization, and my species had some habits that incresead our success.\n\n Like I said, we're arthropods, and is characteristic to left our exoskeleton, known as ecdysis, in the sea floor, this was covered by the sand and maintained until the rock's formation, interacting with the minerals reactions during this process.\n\n This habit of living in the sea floor, and left behind the ecydsis favorized us in the geological register...","You can find my fossil to sell on the internet, we are very abundant, that rocks, and you'll see that we're a very cute animal.\n\nNow, I have a challenge to you.\n\nHelp my specie to burry our ecdysis.\n\n In this game you need to click on the trilobites:\n\n- The first click we will left the ecdysis.\n- Click more 4 times to burry the ecdysis.\n\n", "Be fast, before that our ecydsis rotten, in the final you'll see the rock with the fossils.\n\nWhen you click next, the game will start\n\nGood lucky!"]
    @State var historyPosition = 0
    @State var callTheGame = false

    var gameScene: GameController {
        let gameScene = SKScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFit
        if let gameScene = gameScene as? GameController {
            return gameScene
        } else {
            return GameController()
        }
    }

    var body: some View {
        ZStack {
            Image("bg_st")
                .resizable()
                .scaledToFill()

            ZStack {
                Rectangle()
                    .frame(width: (uiX - 50),height: (uiY - 280), alignment: .center)
                    .border(.black, width: 8)
                    .cornerRadius(20)
                    .offset(CGSize(width: 0, height: -80))
                    .foregroundColor(.init(white: 0.8, opacity: 0.3))
                    .opacity(startStory ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 5)) {
                            startTalking = true
                        }
                    }
                Text(history[historyPosition])
                    .frame(width: (uiX - 70),height: (uiY - 280))
                    .multilineTextAlignment(.center)
                    .offset(CGSize(width: 0, height: -80))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                    .opacity(startStory ? 0.8 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 6)) {
                            return
                        }
                    }
            }

            Image("trilobite")
                .resizable()
                .rotationEffect(isStarted ? Angle(degrees: -180) : Angle(degrees: 0))
                .onAppear  {
                    withAnimation(.easeInOut(duration: 3)) {
                        isStarted = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 3))
                        {
                        self.position = CGSize(width: -40, height: 420)
                        }
                    }
                }
                .rotationEffect(startStory ? Angle(degrees: 200) : Angle(degrees: 0), anchor: .init(x: 0, y: 0))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation(.easeInOut(duration: 3))
                        {
                        self.startStory = true
                        }
                    }
                }
                .offset(position)
                .frame(width: 80,
                       height: 120)
            HStack {

                if historyPosition >= 1 { Button(action: {
                    historyPosition -= 1
                }) {
                    Image("rock_arrow")
                        .rotationEffect(Angle(degrees: 180))
                }.offset(CGSize(width: 0, height: 0))
                }
                NavigationLink(destination: GameCall(gameScene: gameScene).navigationBarBackButtonHidden(true),
                               isActive: $callTheGame,
                               label: {EmptyView()})

                Button {
                    if historyPosition < 4 {
                        historyPosition += 1 } else { callTheGame = true }
                } label: {
                    Image("rock_arrow")
                }.offset(CGSize(width: 30, height: 0))
                    .opacity(startStory ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 5)) {
                            return
                        }
                    }
            }.offset(CGSize(width: 50, height: 280))
        }.ignoresSafeArea()
    }
}

