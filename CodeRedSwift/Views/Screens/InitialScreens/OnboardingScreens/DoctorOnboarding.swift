//
//  DoctorOnboarding.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI

struct DoctorOnboarding: View {
    @ObservedObject var signUpViewModel : SignUpViewModel
    init(suvm : SignUpViewModel) {
        signUpViewModel = suvm
    }
    var body: some View {
        Text("Hello, Doctor!")
        
        Button(action: {
            signUpViewModel.register()
        }, label: {
            Text("Done")
        })
    }
}

