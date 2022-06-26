//
//  Login.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI
import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore


final class LoginViewModel : ObservableObject {
    
    @Published var color = Color.black.opacity(0.7)
    @Published var email = ""
    @Published var pass = ""
    @Published  var visible = false
    
    @Published var alert = false
    @Published var error = ""
    
    func verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res,err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            self.error = "Please fill out all of the contents properly."
            self.alert.toggle()
        }
    }
    
    func reset(){
        if self.email != ""{
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var show: Bool
    
    var body: some View{
        ZStack{
            ZStack(alignment: .topTrailing){
                //            Photo by <a href="https://unsplash.com/@solarfri?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Mira Kireeva</a> on <a href="https://unsplash.com/s/photos/basketball?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
                GeometryReader { geo in
                    Image("sunset_hoop")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width)
                        .edgesIgnoringSafeArea(.all)
                }
                GeometryReader{geometry in
                    VStack {
//                        ZStack{
////                            RoundedRectangle(cornerRadius: 50)
////                                .fill(colors.whiteColor)
////                                .frame(width:200, height:50)
//                            Text("Log In")
//                                .font(.title)
//                                .foregroundColor(colors.whiteColor)
//                                .cornerRadius(50)
//                        }
                        TextField("Email", text: $loginViewModel.email)
                            .autocapitalization(.none)
                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                                    .opacity(1)
//                            )
                            .padding(.top, 25)
                            //.opacity(0.85)
                            HStack{
                                VStack{
                                    if loginViewModel.visible{
                                        TextField("Password", text:$loginViewModel.pass)
                                            .autocapitalization(.none)
                                    } else {
                                        SecureField("Password", text: $loginViewModel.pass)
                                            .autocapitalization(.none)
                                    }
                                    
                                }
                                Button(action: {
                                    loginViewModel.visible.toggle()
                                }) {
                                    Image(systemName: loginViewModel.visible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(loginViewModel.color)
                                }
                            }
                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                            )
                            .padding(.top, 25)
                            .opacity(0.85)
                        Button(action: {
                            loginViewModel.verify()
                        }) {
                            Text("Log In")
                                .foregroundColor(.black)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(.top, 25)
                        HStack{
//                            Spacer()
                            
                            Button(action:{
                                loginViewModel.reset()
                            }) {
                                Text("Forgot password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding(.top, 20)
                        Button(action:{
                            self.show.toggle()
                        }){
                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                        }
                        .padding()

                           
                    }
                    .padding(.horizontal)
                    .frame(height:geometry.size.height/1.5)
                }
                
             
            }
            
            if loginViewModel.alert{
                ErrorView(alert: $loginViewModel.alert, error: $loginViewModel.error)
            }
        }
    }
}

struct ErrorView : View {
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        GeometryReader{geometry in
            VStack{
                HStack{
                    Spacer()
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent" : self.error)
                    .foregroundColor(Color.red)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }){
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(Color.gray)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color.red)
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width-70)
            .background(Color.white)
            .cornerRadius(15)
            .frame(width:geometry.size.width)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
struct ErrorView_Previews : PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(false), error:.constant("Please fill contents properly"))
    }
}

