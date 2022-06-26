//
//  OnboardingHub.swift
//  CodeRedSwift
//
//  Created by Soham Gupta on 6/25/22.
//

import SwiftUI

struct OnboardingHub: View {
    @ObservedObject var signUpViewModel : SignUpViewModel
    
    init(suvm : SignUpViewModel) {
        signUpViewModel = suvm
        if suvm.role == "Citizen" || suvm.role == "Paramedic" {
            suvm.register()
        }
    }
    var body: some View {
        if signUpViewModel.role == "Doctor"  {
            DoctorOnboarding(suvm: signUpViewModel)
        }
    }
}
