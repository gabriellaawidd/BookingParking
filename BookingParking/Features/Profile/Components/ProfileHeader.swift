//
//  ProfileHeader.swift
//  BookingParking
//
//  Created by M. TAQWA ADDARI on 10/07/26.
//

import SwiftUI

struct ProfileHeader: View {
    let initials: String
    let name: String
    let email: String

    var body: some View {
        
        HStack() {
            
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 71, height: 71)

                Text(initials)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
                .frame(width: 25)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                   

                Text(email)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    
                 
            }

    
            Spacer(minLength: 47)

            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .frame(width: 360, height: 94)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}


#Preview {
    ZStack {
        Color.gray.opacity(0.05).ignoresSafeArea()
        
        ProfileHeader(
            initials: "J",
            name: "Judy",
            email: "Judy.Mergo@gmail.com"
        )
    }
}
