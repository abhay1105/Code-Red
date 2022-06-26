//
//  MainView.swift
//  CodeRedSwift
//
//  Created by Soham Gupta on 6/25/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainViewModel = MainViewModel()
    var body: some View {
        VStack {
            if self.mainViewModel.role == "Citizen" || self.mainViewModel.role == "Paramedic" {
                CitizenHome()
            } else if self.mainViewModel.role == "Doctor" {
                DoctorHome()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
