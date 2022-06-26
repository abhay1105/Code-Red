//
//  CitizenHomeScreen.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI
import YouTubePlayerKit

struct CitizenHome: View {
    @State var showingDetail = false
    var body: some View {
        VStack {
            Button(action: {
                self.showingDetail.toggle()
            }, label: {
                Text("Report Emergency")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            })
            .background(Color.red)
            .cornerRadius(50)
            .padding(.top, 25)
            .sheet(isPresented: $showingDetail) {
                AudioContentView()
            }
    
           
            Text("Hello, Soham Gupta!")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .padding()
            ScrollView {
                YouTubePlayerView("https://www.youtube.com/watch?v=hizBdM1Ob68")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
                YouTubePlayerView("https://www.youtube.com/watch?v=gDwt7dD3awc")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
                YouTubePlayerView("https://www.youtube.com/watch?v=ebkQtGAqfis")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
                YouTubePlayerView("https://www.youtube.com/watch?v=2v8vlXgGXwE")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
                YouTubePlayerView("https://www.youtube.com/watch?v=FE7VSxA98a8")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
                YouTubePlayerView("https://www.youtube.com/watch?v=CnbjPFwkiTQ")
                    .frame(width: 0.9 * UIScreen.main.bounds.width, height: 0.2 * UIScreen.main.bounds.height)
                    .cornerRadius(15)
                    .padding(.bottom)
            }
        }
    }
}

struct CitizenHome_Previews: PreviewProvider {
    static var previews: some View {
        CitizenHome()
    }
}
