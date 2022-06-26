//
//  MainViewModel.swift
//  CodeRedSwift
//
//  Created by Soham Gupta on 6/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class MainViewModel : ObservableObject {
    @Published var role : String = ""
    let db = Firestore.firestore()
    init() {
        getUserRole()
    }
    //FIREBASE CALLERS
    func getUserRole(){

        var roleIdentity = ""


        let docRef = self.db.collection("doctors").document(Auth.auth().currentUser?.uid ?? "")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                roleIdentity = "Doctor"
                self.role = "Doctor"
            } else {
                print("Doctor Document does not exist")
            }
        }

        let docRef1 = self.db.collection("people").document(Auth.auth().currentUser?.uid ?? "")

        docRef1.getDocument { (document, error) in
            if let document = document, document.exists {
                roleIdentity = "Citizen"
                self.role = "Citizen"
            } else {
                print("People Document does not exist")
            }
        }

        let docRef2 = self.db.collection("paramedics").document(Auth.auth().currentUser?.uid ?? "")

        docRef2.getDocument { (document, error) in
            if let document = document, document.exists {
                roleIdentity = "Paramedic"
                self.role = "Paramedic"
            } else {
                print("Para Document does not exist")
            }
        }

        self.role = roleIdentity
        
        print(self.role)

    }
    
}
