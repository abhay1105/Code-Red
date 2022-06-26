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
    }
    var body: some View {
        if signUpViewModel.role == "Citizen" || signUpViewModel.role == "Paramedic"  {
            CitizenParaOnboarding(suvm: signUpViewModel)
        }
        
        if signUpViewModel.role == "Doctor"  {
            DoctorOnboarding(suvm: signUpViewModel)
        }
    }
}
