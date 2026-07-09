import SwiftUI

struct ChooseVoucherView: View {
    
    var body: some View {
        VStack{
            Text("You don't have any vouchers to redeem yet")
            Text("Start earning points to unlock vouchers!")
        }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
}

#Preview {
    ChooseVoucherView()
}
