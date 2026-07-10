import SwiftUI


struct ProfilePageView: View {
//  @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
           
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                header
                
                
                ScrollView(showsIndicators: false) {
                    
                    
                    VStack(alignment: .leading, spacing: 28) {
                        
                        
                        ProfileHeader(
                            initials: "J",
                            name: "Judy",
                            email: "Judy.Margo@gmail.com"
                        )
                        
                       
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Loyalty Card")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            
                            LoyaltyLevelCard()
                        }
                        
                       
                        VStack(alignment: .leading, spacing: 12) {
                            Text("My Vehicles")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            
                            VehicleListItem(
                                vehicle: Vehicle(name: "Toyota Avanza", licensePlate: "B 5678 CDE"),
                                onTap: {
                          
                                }
                            )
                        }
                        
                       
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account Settings")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 1/255, green: 31/255, blue: 75/255))
                            
                          
                            VStack(spacing: 0) {
                                SettingsMenuRow(icon: "bell", title: "Notification Settings", onTap: {})
                                
                                Divider().padding(.leading, 46)
                                
                                SettingsMenuRow(icon: "questionmark.circle", title: "Help Center", onTap: {})
                                
                                Divider().padding(.leading, 46)
                                
                                SettingsMenuRow(icon: "info.circle", title: "About Us", onTap: {})
                            }
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                         
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("Profile")
                
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
}


#Preview {
    ProfilePageView()
}
