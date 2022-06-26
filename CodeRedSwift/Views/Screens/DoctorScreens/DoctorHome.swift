//
//  DoctorHome.swift
//  CodeRedSwift
//
//  Created by Abhay Paidipalli on 6/25/22.
//
//

//  ContentView.swift

//  CodeRedScreens

//

//  Created by Abhay Paidipalli on 6/25/22.

//



import SwiftUI



struct DoctorHome: View {

    var body: some View {

        Text("Hello, Saksham Gupta!")

            .font(.system(size: 40))

            .fontWeight(.bold)

        Text("Alerts")

            .font(.system(size: 30))

            .fontWeight(.semibold)

        ScrollView {

            StoreRow(

                title: "Soham Gupta",

                address: "Saint Alexian Brothers Hospital",

                city: "Schaumburg, Illinois",

                categories: ["Surgery"],

                kilometres: 0

            )

            StoreRow(

                title: "Loretta Johnson",

                address: "AMITA Health Center",

                city: "Hoffman Estates, Illinois",

                categories: ["Cardio", "Neuro", "Ortho"],

                kilometres: 0

            )

            StoreRow(

                title: "Stephen James",

                address: "Saint Alexian Brothers Hospital",

                city: "Schaumburg, Illinois",

                categories: ["Opto"],

                kilometres: 0

            )

            StoreRow(

                title: "Roquan Willis",

                address: "AMITA Health Center",

                city: "Hoffman Estates, Illinois",

                categories: ["Cardio", "Anesthesio"],

                kilometres: 0

            )

        }

    }

}





extension UIColor {

    

    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)

    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)

    

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)

    }

}



extension Color {

    public init(decimalRed red: Double, green: Double, blue: Double) {

        self.init(red: red / 255, green: green / 255, blue: blue / 255)

    }

    

    public static var flatDarkBackground: Color {

        return Color(decimalRed: 36, green: 36, blue: 36)

    }

    

    public static var flatDarkCardBackground: Color {

        return Color(decimalRed: 46, green: 46, blue: 46)

    }

}



extension Color {

    init(hex: UInt, alpha: Double = 1) {

        self.init(

            .sRGB,

            red: Double((hex >> 16) & 0xff) / 255,

            green: Double((hex >> 08) & 0xff) / 255,

            blue: Double((hex >> 00) & 0xff) / 255,

            opacity: alpha

        )

    }

}



struct StoreRow: View {

    

    // audio, text, name of patient, paramedic/person

    

    var title: String

    var address: String

    var city: String

    var categories: [String]

    var kilometres: Double

    var showSheet: Bool = false

    

    var body: some View {

        ZStack(alignment: .leading) {

            

            Color.flatDarkCardBackground

            HStack {

                ZStack {

                    Circle()

                        .fill(

                            LinearGradient(

                                gradient: Gradient(colors: [Color(hex: 0xff7f7f), Color(hex: 0x8b0000)]),

                                startPoint: .topLeading,

                                endPoint: .bottomTrailing

                            )

                        )

                    Image(systemName: "person.fill")

                        .resizable()

                        .foregroundColor(.white)

                        .frame(width: 30, height: 25)

                }

                .frame(width: 70, height: 70, alignment: .center)

                

                VStack(alignment: .leading) {

                    Text(title)

                        .font(.headline)

                        .fontWeight(.bold)

                        .foregroundColor(.white)

                        .lineLimit(2)

                        .padding(.bottom, 5)

                    

                    Text(address)

                        .padding(.bottom, 5)

                        .foregroundColor(.white)

                    

                    HStack(alignment: .center) {

                        Image(systemName: "mappin")

                            .foregroundColor(.white)

                        Text(city)

                            .foregroundColor(.white)

                    }

                    .padding(.bottom, 5)

                    

                    HStack {

                        ForEach(categories, id: \.self) { category in

                            CategoryPill(categoryName: category)

                        }

                    }

                }

                .padding(.horizontal, 5)

            }

            .padding(15)

        }

        .clipShape(RoundedRectangle(cornerRadius: 15))

    }

}



struct CategoryPill: View {

    

    var categoryName: String

    var fontSize: CGFloat = 12.0

    

    var body: some View {

        ZStack {

            Text(categoryName)

                .font(.system(size: fontSize, weight: .regular))

                .lineLimit(2)

                .foregroundColor(.white)

                .padding(5)

                .background(Color.green)

                .cornerRadius(5)

        }

    }

}


