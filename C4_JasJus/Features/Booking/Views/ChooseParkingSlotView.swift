import SwiftUI

struct ChooseParkingSlotView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: ParkingLotViewModel

    init(mall: Mall) {
        _viewModel = StateObject(wrappedValue: ParkingLotViewModel(mall: mall))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dateTimeCard
                    legend
                    floorPlanCard
                    if let selected = viewModel.selectedSlotID {
                        selectedSummary(selected)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
                .padding(.top, 8)
            }
            reserveBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: Header
    private var header: some View {
        HStack(spacing: 14) {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            Text(viewModel.mall.name)
                .font(.title3.bold())
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 54)
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
    }

    // MARK: Date/time card
    private var dateTimeCard: some View {
        VStack(spacing: 0) {
            dateTimeRow(title: "Date", systemImage: "calendar") {
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            Divider().padding(.leading, 44)
            dateTimeRow(title: "Start Time", systemImage: "clock") {
                DatePicker("", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
            Divider().padding(.leading, 44)
            dateTimeRow(title: "End Time", systemImage: "clock.badge.checkmark") {
                DatePicker("", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    private func dateTimeRow<Content: View>(title: String, systemImage: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        DisclosureGroup {
            content()
                .padding(.top, 4)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                Text(title)
                    .font(.subheadline.bold())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    // MARK: Legend
    private var legend: some View {
        HStack(spacing: 24) {
            legendItem(color: SlotStatus.available.color, label: "Available")
            legendItem(color: SlotStatus.occupied.color, label: "Occupied")
            legendItem(color: SlotStatus.priority.color, label: "Priority")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 14, height: 14)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: Floor plan card
    private var floorPlanCard: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 14) {
                ForEach(viewModel.sections) { section in
                    HStack(alignment: .top, spacing: 6) {
                        ForEach(section.columns) { col in
                            VStack(spacing: 4) {
                                ForEach(col.codes, id: \.self) { code in
                                    slotCell(code)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 16)

            HStack(spacing: 8) {
                ForEach(["P1","P2","P3","P4"], id: \.self) { code in
                    slotCell(code)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    private func slotCell(_ code: String) -> some View {
        let status = viewModel.statusFor(code)
        let isSelected = viewModel.selectedSlotID == code
        let isHandicap = viewModel.isHandicap(code)

        return Button {
            viewModel.select(code)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(status.color.opacity(isSelected ? 1 : 0.75))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(isSelected ? Color.blue : .clear, lineWidth: 2.5)
                    )
                    .shadow(color: isSelected ? .blue.opacity(0.35) : .clear, radius: 4)

                if isHandicap {
                    Image(systemName: "figure.roll")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Text(code)
                        .font(.system(size: 8.5, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 32, height: 32)
        }
        .disabled(status == .occupied)
        .opacity(status == .occupied ? 0.55 : 1)
    }

    // MARK: Selected slot summary
    private func selectedSummary(_ code: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text("Slot \(code) selected")
                    .font(.subheadline.bold())
                Text("\(viewModel.dateLabel) • \(viewModel.timeRangeLabel)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.blue.opacity(0.08))
        .cornerRadius(14)
    }

    // MARK: Bottom bar — save ke router draft
    private var reserveBar: some View {
        Button {
            router.draftDate = viewModel.selectedDate
            router.draftStartTime = viewModel.startTime
            router.draftEndTime = viewModel.endTime
            router.draftSlotID = viewModel.selectedSlotID
            router.pop()
        } label: {
            Text(viewModel.selectedSlotID == nil ? "Select a Slot" : "Reserve Parking")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canReserve ? Color.blue : Color.gray.opacity(0.4))
                .cornerRadius(16)
        }
        .disabled(!viewModel.canReserve)
        .padding()
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.05), radius: 8, y: -2)
        )
    }
}
