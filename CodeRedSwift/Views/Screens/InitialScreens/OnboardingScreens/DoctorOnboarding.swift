//
//  DoctorOnboarding.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//

import SwiftUI

struct DoctorOnboarding: View {
    
    @ObservedObject var signUpViewModel: SignUpViewModel
    var multi_select: MultipleSelectionList = MultipleSelectionList()
    
    init(suvm: SignUpViewModel) {
        signUpViewModel = suvm
    }
    
    var body: some View {
        Form {
            
            Section(header: Text("Contact Information")) {
                Text("Please enter your most convenient phone number below. Separate with dashes.")
                TextField("(000)-000-0000", text: $signUpViewModel.phone_number)
                    .autocapitalization(.none)
                    .padding()
            }
            
            Section(header: Text("Hospital Identification")) {
                Text("Enter the four-digit code provided by your hospital.")
                TextField("----", text: $signUpViewModel.hospital_code)
                    .autocapitalization(.none)
                    .padding()
            }
            
            Section(header: Text("Specialization")) {
                Text("Mark all options that pertain to your field of medical expertise.")
                multi_select
            }
            
        }
        
        Button(action: {
            var tempList = ""
            for index in 0..<multi_select.$selections.count {
                if index != multi_select.selections.count - 1 {
                    tempList = tempList + "\(multi_select.selections[index]),"
                } else {
                    tempList = tempList + "\(multi_select.selections[index])"
                }
            }
            signUpViewModel.specialization_list = tempList
            signUpViewModel.register()
        }, label: {
            Text("Done")
        })
        
    }
}

struct MultipleSelectionList: View {
    @State var items: [String] = ["Cardiologist", "Pediatrician", "Surgeon", "Orthopedic", "Neurologist", "Anesthesiologist", "Optometrist"]
    @State var selections: [String] = []

    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
                    if self.selections.contains(item) {
                        self.selections.removeAll(where: { $0 == item })
                    }
                    else {
                        self.selections.append(item)
                    }
                }
            }
        }
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

