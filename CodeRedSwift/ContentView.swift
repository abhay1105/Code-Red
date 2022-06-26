//
//  ContentView.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
            VStack{
                if self.status{
                   // NavigationView {
                        VStack {
                            MainView()
                            
                            Button(action:{
                                try! Auth.auth().signOut()
                                UserDefaults.standard.set(false, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            self.status = false

                            }){
                                Text("Log Out")
                            }
                        }
                    //}
                } else {
                    NavigationView {
                        VStack{
                            ZStack{
                                NavigationLink(destination: SignUp(show: self.$show),isActive: self.$show){
                                    Text("Error is occuring at the moment, sorry")
                                }
                                .hidden()
                                    LoginView(show: self.$show)
                            }
                        }
                        .onAppear() {
                            NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                                self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                            }
                        }
                    }
                }
            }
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


