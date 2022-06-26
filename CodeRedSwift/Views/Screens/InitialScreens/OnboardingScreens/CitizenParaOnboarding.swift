//
//  CitizenParaOnboarding.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI

struct CitizenParaOnboarding: View {
    @ObservedObject var signUpViewModel: SignUpViewModel
    
    init(suvm: SignUpViewModel) {
        signUpViewModel = suvm
    }
    var body: some View {
        VStack {
            Text("Hello, Citizen!")
            
            Button(action: {
                signUpViewModel.register()
            }, label: {
                Text("Done")
            })
        }
    }
}

