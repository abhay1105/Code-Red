//
//  Register.swift
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


struct SignUp: View {
    
    @Binding var show: Bool
    
    @StateObject var signUpViewModel = SignUpViewModel()
    
        
    var body: some View {
            ZStack(alignment: .topLeading){
                GeometryReader{geometry in
                    VStack {
                        Text("Register")
                            .font(.title)
                            .foregroundColor(Color.black)
                            .cornerRadius(50)
                        TextField("Email", text: $signUpViewModel.email)
                            .autocapitalization(.none)
                            .padding()
                            .opacity(0.85)
                            .foregroundColor(Color.gray)
                        
                        //Password field
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
                        .opacity(0.85)
                        // re-enter password
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
                        .padding(.top, 25)
                        .opacity(0.85)
                
                        // full name entry
                        HStack{
                            VStack{
                                TextField("Full Name", text: $signUpViewModel.full_name)
                                    .autocapitalization(.none)
                                    .padding()
                                    .padding(.top, 25)
                                    .opacity(0.85)
                            }
                        }
                        
                        // menu
                        Menu {
                            Button {
                                signUpViewModel.role = "Citizen"
                            } label: {
                                Text("Citizen")
                                Image(systemName: "arrow.down.right.circle")
                            }
                            Button {
                                signUpViewModel.role = "Doctor"
                            } label: {
                                Text("Doctor")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                            Button {
                                signUpViewModel.role = "Paramedic"
                            } label: {
                                Text("Paramedic")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                        } label: {
                             Text("Select a role")
                             Image(systemName: "tag.circle")
                        }
                        
                        HStack{
                            VStack{
                                Text("Role: \(signUpViewModel.role)")
                                    .padding()
                                    .opacity(0.85)
                            }
                        }
                        
                        // register button
                        NavigationLink(destination: {
                            OnboardingHub(suvm: signUpViewModel)
                            // THIS SHOULD RUN SIGN UP VIEW MODEL . REGISTER
                        }, label: {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        })
                        .background(Color.red)
                        .cornerRadius(50)
                        .padding(.top, 25)
  
                    }
                    .padding(.horizontal, 25)
                    .frame(height:geometry.size.height/1.5)
                            
                }
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
    @Published var full_name = ""
    @Published var role = ""
    @Published var alert = false
    @Published var error = ""
    @Published var hospital_code = ""
    @Published var phone_number = ""
    @Published var specialization_list : [String] = []
    let db = Firestore.firestore()
    
    func register() {
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
                    
                    if role == "Citizen" {
                        // add the user to the users section of the database
                        db.collection("people").document(Auth.auth().currentUser?.uid ?? "").setData([
                            "email": self.email,
                            "full_name": self.full_name,
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print(self.specialization_list)
                                print("Document successfully written!")
                            }
                        }
                        
                    } else if role == "Doctor" {
                        // add the user to the users section of the database
                        print("WE ARE GETTING HERE")
                        db.collection("hospitaldoctor").document(Auth.auth().currentUser?.uid ?? "").setData([
                            "email": self.email,
                            "full_name": self.full_name,
                            "phone_number": self.phone_number,
                            "hospital_code": self.hospital_code,
                            "specialization_list": self.specialization_list
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    } else if role == "Paramedic" {
                        // add the user to the users section of the database
                        db.collection("paramedics").document(Auth.auth().currentUser?.uid ?? "").setData([
                            "email": self.email,
                            "full_name": self.full_name,
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
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
