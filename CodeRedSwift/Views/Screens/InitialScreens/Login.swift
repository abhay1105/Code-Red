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

struct Login: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct SignUp: View {
    
    @Binding var show: Bool
    
    @StateObject var signUpViewModel = SignUpViewModel()
        
    var body: some View {

            ZStack(alignment: .topLeading){
                GeometryReader { geo in
                    // Photo by Mira Kireeva on Unsplash
                    Image("girl-shooting")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width)
                        .edgesIgnoringSafeArea(.all)
                }
                GeometryReader{geometry in
                    VStack {
                        Text("Register")
                            .font(.title)
                            .foregroundColor(Color.black)
                            .cornerRadius(50)
                        TextField("Email", text: $signUpViewModel.email)
                            .autocapitalization(.none)
                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                            )
                            .padding(.top, 25)
                            .opacity(0.85)
                            .foregroundColor(Color.gray)
                        HStack{
                            VStack{
                                if signUpViewModel.visible{
                                    TextField("Password", text:$signUpViewModel.pass)
                                        .autocapitalization(.none)
                                        .foregroundColor(Color.red)
                                } else {
                                    SecureField("Password", text: $signUpViewModel.pass)
                                        .autocapitalization(.none)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            Button(action: {
                                signUpViewModel.visible.toggle()
                            }) {
                                Image(systemName: signUpViewModel.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(signUpViewModel.color)
                            }
                        }
                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                        )
                        .padding(.top, 25)
                        .opacity(0.85)
                            
                        HStack{
                            VStack{
                                if signUpViewModel.revisible{
                                    TextField("Re-enter", text:$signUpViewModel.repass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Re-enter", text: $signUpViewModel.repass)
                                        .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                signUpViewModel.revisible.toggle()
                            }) {
                                Image(systemName: signUpViewModel.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(signUpViewModel.color)
                            }
                        }
                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                        )
                        .padding(.top, 25)
                        .opacity(0.85)
                
                        
                        HStack{
                            VStack{
                                TextField("Username", text: $signUpViewModel.username)
                                    .autocapitalization(.none)
                                    .padding()
//                                    .background(
//                                        RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                                    )
                                    .padding(.top, 25)
                                    .opacity(0.85)
                            }
                        }
                        
                        Button(action: {
                            signUpViewModel.register()
                        }) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                    .frame(height:geometry.size.height/1.5)
                            
                }
                
//                Button(action:{
//                    self.show.toggle()
//                }){
//                    Image(systemName: "chevron.left")
//                        .font(.title)
//                        .foregroundColor(Color.blue)
//                }
//                .padding()
            }
            
            if signUpViewModel.alert{
                ErrorView(alert: $signUpViewModel.alert, error: $signUpViewModel.error)
            }
        }
        
}


final class SignUpViewModel: ObservableObject {
    @Published var color = Color.black.opacity(0.7)
    @Published var visible = false
    @Published var revisible = false
    @Published var email = ""
    @Published var pass = ""
    @Published var repass = ""
    @Published var username = ""
    @Published var alert = false
    @Published var error = ""
    let db = Firestore.firestore()
    
    func register(){
        if self.email != ""{
            if self.pass == self.repass{
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { [self]
                    (res,err) in
                    if err != nil{
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("success")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    print(NSNotification.Name("status"))
                    
                    // add the user to the users section of the database
                    db.collection("users").document(Auth.auth().currentUser?.uid ?? "").setData([
                        "email": self.email,
                        "username": self.username,
                        "teams" : [],
                        "workouts" : []
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            } else {
                self.error = "Password Mismatch"
                self.alert.toggle()
            }
        } else {
            self.error = "Please fill all of the contents properly"
            self.alert.toggle()
        }
    }
    
}

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

