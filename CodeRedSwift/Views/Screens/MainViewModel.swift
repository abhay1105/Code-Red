//
//  MainViewModel.swift
//  CodeRedSwift
//
//  Created by Soham Gupta on 6/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

final class MainViewModel : ObservableObject {
    @Published var role : String = ""
    @Published var huid : String = ""
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
    
    func getHospitalCode(){
        let docRef = self.db.collection("doctors").document(Auth.auth().currentUser?.uid ?? "")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                self.huid = dataDescription["hospital_code"] as! String
            } else {
                print("People Document does not exist")
            }
        }
    }
    
    // FIREBASE WRITERS
    
    func saveAudioFile(audioPath : URL) {
        let metadata = StorageMetadata()
            metadata.contentType = "audio/m4a"
            let riversRef = Storage.storage().reference().child("Audio").child("\(Date()).m4a")
            do {
                print("above")
                let audioData = try audioPath.dataRepresentation
                print("below")
                riversRef.putData(audioData, metadata: metadata){ (data, error) in
                    if error == nil{
                        print("se guardo el audio")
                        riversRef.downloadURL {url, error in
                            guard let downloadURL = url else { return }
                            print("el url descargado")
                        }
                    }
                    else {
                        if let error = error?.localizedDescription{
                            print("error al cargar imagen")
                        }
                        else {
                            print("error de codigo")
                        }
                    }
                }
            } catch {
                print("LOCAL BLAH")
                print(error.localizedDescription)
            }
            
    
    }
    
    // write to firebase
//    hospital_code
//    "1111"
//    (string)
//    huid
//    "UrNVO3FgeWYLb0ZgMuFW9B4pStc2"
//    lat
//    "123"
//    lng
//    "345"
//    name
//    "John Doe"
//    puid
//    "EA06wUF0WwS5fE2N2t1FCU9JQ0T2"
//    type
//    "Person"
//    vmtext
//    "help help i have chest pain help help"
//    vmurl
    func submitPersonEmergency() {
        print("HOSPITAL CODE: \(getHospitalCode())")
        db.collection("peopleemergencies").document().setData([
            "hospital_code": "1111",
            "huid": "UrNVO3FgeWYLb0ZgMuFW9B4pStc2",
            "lat":"27.2046",
            "lng":"77.4977",
            "name":"Soham Gupta",
            "puid":Auth.auth().currentUser?.uid,
            "type":"Person",
            "vmtext":"my brother has fallen and got his leg stuck between rocks he may need surgery",
            "vmurl": "https://firebasestorage.googleapis.com/v0/b/codered-d903c.appspot.com/o/Audio%2FRev.mp3?alt=media&token=0c41fe23-e5e1-4eb7-84de-f714f4f742e7",
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
