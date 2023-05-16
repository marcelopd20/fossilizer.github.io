import SwiftUI

struct ContentView: View {
    @State private var position = CGSize(width: 0, height: UIScreen.main.bounds.height)
    @State private var isShowing = false
    @State var storyTelling = false
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                Image("bg_start")
                    .resizable()
                    .scaledToFill()
                
                Image("trilobite")
                    .resizable()
                    .offset(position)
                    .frame(width: 80,
                           height: 120)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3)){
                            self.position = CGSize(width: 0, height: 0)
                        }
                    }
                
                VStack () {
                    
                    Image("title")
                        .resizable()
                        .scaledToFit()
                        .offset(y: -(UIScreen.main.bounds.height)/3)
                    
                    Button(action: {
                        storyTelling = true
                    }){
                        Image("start_button")
                            .resizable()
                            .frame(width:209, height:73)
                            .scaledToFit()
                    }
                    .offset(y: UIScreen.main.bounds.height/3)
                }.scaledToFit()
                    .opacity(isShowing ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 3))
                            {
                            self.isShowing = true
                            }
                        }
                    }
                NavigationLink(destination:
                                StoryTelling().navigationBarBackButtonHidden(true),
                               isActive: $storyTelling,
                               label: {EmptyView()})
            }.ignoresSafeArea()
            
            
        }
    }
    
}
