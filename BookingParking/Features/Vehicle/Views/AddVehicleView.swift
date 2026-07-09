import SwiftUI

struct AddVehicleView: View {
    let viewModel: BookingFormViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var prefix: String = ""
    @State private var number: String = ""
    @State private var suffix: String = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case prefix, number, suffix
    }

    private var licensePlate: String {
        "\(prefix) \(number) \(suffix)"
    }

    private var isValid: Bool {
        !prefix.isEmpty && !number.isEmpty && !suffix.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "car.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.primary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Add Vehicle")
                        .font(.largeTitle.bold())
                    Text("Enter your vehicle's license plate.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 10) {
                    plateField("AB", text: $prefix, maxLength: 2, field: .prefix)
                    plateField("1234", text: $number, maxLength: 4, field: .number)
                    plateField("CDE", text: $suffix, maxLength: 3, field: .suffix)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.addVehicle(Vehicle(name: "Kendaraan", licensePlate: licensePlate))
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(isValid ? Color.accentColor : Color(.systemGray4))
                            .clipShape(Circle())
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func plateField(_ placeholder: String, text: Binding<String>, maxLength: Int, field: Field) -> some View {
        TextField(placeholder, text: text)
            .font(.title2.bold())
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.characters)
            .keyboardType(field == .number ? .numberPad : .asciiCapable)
            .focused($focusedField, equals: field)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .onChange(of: text.wrappedValue) { _, newValue in
                let filtered = String(newValue.uppercased().prefix(maxLength))
                text.wrappedValue = filtered
                if filtered.count == maxLength {
                    advanceFocus(from: field)
                }
            }
    }

    private func advanceFocus(from field: Field) {
        switch field {
        case .prefix: focusedField = .number
        case .number: focusedField = .suffix
        case .suffix: focusedField = nil
        }
    }
}

#Preview {
    AddVehicleView(viewModel: BookingFormViewModel(mall: .sample))
}
