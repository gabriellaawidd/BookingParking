
import SwiftUI

struct ChooseParkingSlotView: View {
    @State var bookingViewModel: BookingFormViewModel
    @State var viewModel: ParkingLotViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isDateExpanded = false
    @State private var isStartTimeExpanded = false
    @State private var isEndTimeExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    dateTimeCard
                    legend
                    floorPlanCard

                    if viewModel.canReserve, let selected = viewModel.selectedSlotID {
                        selectedSummary(selected)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                
                reserveBar
                    .padding(.bottom)
            }
    
        }
        .navigationTitle(viewModel.mall.name)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)

        .onAppear{
            if viewModel.selectedSlotID != bookingViewModel.selectedSlot {
                viewModel.selectedSlotID = bookingViewModel.selectedSlot
            }
            if let date = bookingViewModel.bookingDate, viewModel.selectedDate != date {
                viewModel.selectedDate = date
            }
            if let start = bookingViewModel.startTime, viewModel.startTime != start {
                viewModel.startTime = start
                viewModel.hasSetStartTime = true
            }
            if let end = bookingViewModel.endTime, viewModel.endTime != end {
                viewModel.endTime = end
                viewModel.hasSetEndTime = true
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var dateTimeCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Date")
                    .font(.headline)
                Spacer()
                pillButton(text: viewModel.dateLabel) {
                    withAnimation { isDateExpanded.toggle() }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)

            if isDateExpanded {
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }

            Divider().padding(.horizontal, 24)

            HStack {
                Text("Start Time")
                    .font(.headline)
                Spacer()
                pillButton(text: viewModel.startTimeLabel) {
                    withAnimation { isStartTimeExpanded.toggle() }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)

            if isStartTimeExpanded {
                TimeIntervalBooking(selection: $viewModel.startTime, minuteInterval: 15, minHour: 10, maxHour: 23)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                    .onChange(of: viewModel.startTime) { _, _ in
                        viewModel.hasSetStartTime = true
                        viewModel.timeValidation()
                    }
            }

            Divider().padding(.horizontal, 24)

            HStack {
                Text("End Time")
                    .font(.headline)
                Spacer()
                pillButton(text: viewModel.endTimeLabel) {
                    withAnimation { isEndTimeExpanded.toggle() }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)

            if isEndTimeExpanded {
                TimeIntervalBooking(selection: $viewModel.endTime, minuteInterval: 15, minHour: 10, maxHour: 23)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)
                    .onChange(of: viewModel.endTime) { _, _ in
                        viewModel.hasSetEndTime = true
                        viewModel.timeValidation()
                    }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
    }
    
    private func pillButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(.systemGray5))
                )
        }
    }

    private func dateTimeLabel(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 10) {

            Text(title)
                .font(.subheadline.bold())

            Spacer()

            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var legend: some View {
        HStack(spacing: 24) {
            legendItem(color: SlotStatus.available.color, label: "Available")
            legendItem(color: SlotStatus.occupied.color, label: "Occupied")
            legendItem(color: SlotStatus.priority.color, label: "Priority")

        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 14, height: 14)
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    private var floorPlanCard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 24) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(viewModel.sections) { section in
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(section.columns) { col in
                                VStack(spacing: 6) {
                                    ForEach(col.codes, id: \.self) { code in
                                        slotCell(code)
                                    }
                                }
                            }
                        }
                    }
                }

                HStack(spacing: 10) {
                    ForEach(["P1", "P2", "P3", "P4"], id: \.self) { code in
                        slotCell(code)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
    }

    private func slotCell(_ code: String) -> some View {
        let status = viewModel.statusFor(code)
        let isSelected = viewModel.selectedSlotID == code
        let isHandicap = viewModel.isHandicap(code)

        return Button {
            withAnimation(.easeOut(duration: 0.15)) {
                viewModel.select(code)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(status.color.opacity(isSelected ? 1 : 0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(isSelected ? Color.blue : .clear, lineWidth: 2.5)
                    )
                    .shadow(color: isSelected ? .blue.opacity(0.35) : .clear, radius: 4)

                if isHandicap {
                    Image(systemName: "figure.roll")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Text(code)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 34, height: 34)
        }
        .disabled(status == .occupied)
        .opacity(status == .occupied ? 0.5 : 1)
    }

    private func selectedSummary(_ code: String) -> some View {
        VStack(spacing: 2) {
            Text("Slot \(code)")
                .font(.headline)
            Text("\(viewModel.dateLabel) • \(viewModel.timeRangeLabel)")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
        )
    }

    private var reserveBar: some View {
        Button {
            if let slot = viewModel.selectedSlotID {
                bookingViewModel.applySlotSelection(
                    slotID: slot,
                    date: viewModel.selectedDate,
                    start: viewModel.startTime,
                    end: viewModel.endTime
                )
            }
            dismiss()
        } label: {
                    Text("Reserve Parking")
                        .font(.headline)
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canReserve ? Color.blue : Color.gray.opacity(0.4))
                        .cornerRadius(16)
                
        }
        .disabled(!viewModel.canReserve)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
}

#Preview {
    ChooseParkingSlotView(
        bookingViewModel: BookingFormViewModel(mall: .sample),
        viewModel: ParkingLotViewModel(mall: .sample)
    )
}
