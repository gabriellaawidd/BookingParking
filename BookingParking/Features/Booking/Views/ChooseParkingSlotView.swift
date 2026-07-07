// MARK: - ChooseParkingSlotView.swift
import SwiftUI

struct ChooseParkingSlotView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel: ParkingLotViewModel
    
    @State private var isDateExpanded = false
    @State private var isStartTimeExpanded = false
    @State private var isEndTimeExpanded = false
    var minuteInterval: Int = 15

    init(mall: Mall) {
        _viewModel = StateObject(wrappedValue: ParkingLotViewModel(mall: mall))
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    dateTimeCard
                    legend
                    floorPlanCard

                    if let selected = viewModel.selectedSlotID {
                        selectedSummary(selected)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }

            reserveBar
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
    }

    // MARK: - Header
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
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 54)
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
    }

    // MARK: - Date/time card
    private var dateTimeCard: some View {
        VStack(spacing: 0) {
            DisclosureGroup(isExpanded: $isDateExpanded){
                DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.top, 4)
                    .onChange(of: viewModel.selectedDate) {_, _ in
                        withAnimation {
                            isDateExpanded = false
                        }
                    }
            }label: {
                dateTimeLabel(title: "Date", value: viewModel.dateLabel, systemImage: "calendar")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider().padding(.leading, 46)
            
            DisclosureGroup(isExpanded: $isStartTimeExpanded){
                TimeIntervalBooking(selection: $viewModel.startTime, minuteInterval: minuteInterval)
                    .frame(height: 150)
                    .padding(.top, 4)
                    .onChange(of: viewModel.startTime) {_, _ in
                        withAnimation {
                            isStartTimeExpanded = false
                        }
                    }
            }label: {
                dateTimeLabel(title: "Start Time", value: viewModel.startTimeLabel, systemImage: "calendar")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider().padding(.leading, 46)
            
            DisclosureGroup(isExpanded: $isEndTimeExpanded){
                TimeIntervalBooking(selection: $viewModel.endTime, minuteInterval: minuteInterval)
                    .frame(height: 150)
                    .padding(.top, 4)
                    .onChange(of: viewModel.endTime) {_, _ in
                        withAnimation {
                            isEndTimeExpanded = false
                        }
                    }
            }label: {
                dateTimeLabel(title: "End Time", value: viewModel.endTimeLabel, systemImage: "calendar")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider().padding(.leading, 46)

        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        )
    }

    private func dateTimeLabel(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .frame(width: 22)

            Text(title)
                .font(.subheadline.bold())

            Spacer()

            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Legend
    private var legend: some View {
        HStack(spacing: 24) {
            legendItem(color: SlotStatus.available.color, label: "Available")
            legendItem(color: SlotStatus.occupied.color, label: "Occupied")
            legendItem(color: SlotStatus.priority.color, label: "Priority")
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Floor plan card
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

    // MARK: - Selected slot summary
    private func selectedSummary(_ code: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
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
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.opacity(0.08))
        )
    }

    // MARK: - Bottom bar
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
