// MARK: - TicketPageView.swift
import SwiftUI

struct TicketPageView: View {
    @EnvironmentObject var router: AppRouter
    @State private var selectedSegment: TicketSegment = .schedule

    enum TicketSegment {
        case schedule, history
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                header

                segmentedControl
                    .padding(.horizontal)
                    .padding(.top, 16)

                sectionTitle
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 16) {
                        if selectedSegment == .schedule {
                            ForEach(TicketReservation.upcomingList) { reservation in
                                ScheduleCard(reservation: reservation)
                            }
                        } else {
                            ForEach(TicketReservation.historyList) { reservation in
                                HistoryCard(reservation: reservation)
                            }
                        }
                    }
                    .padding(.horizontal)
//                    .padding(.bottom, 100) // ruang supaya tidak ketutup tab bar
                }
            }

            HomeTabBarPill()
                .padding(.horizontal)
                .padding(.bottom, 12)
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        Text("Ticket")
            .font(.largeTitle.bold())
            .padding(.horizontal)
            .padding(.top, 60)
            .padding(.bottom, 8)
    }

    private var sectionTitle: some View {
        HStack {
            Text(selectedSegment == .schedule ? "Upcoming Reservation" : "Past Reservation")
                .font(.headline)
            Spacer()
        }
    }

    private var segmentedControl: some View {
        HStack(spacing: 0) {
            SegmentButton(title: "Schedule", isSelected: selectedSegment == .schedule) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSegment = .schedule
                }
            }
            SegmentButton(title: "History", isSelected: selectedSegment == .history) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    selectedSegment = .history
                }
            }
        }
        .background(Color(.systemGray6))
        .clipShape(Capsule())
    }
}

// MARK: - Segment Button
struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? Color(red: 0.05, green: 0.2, blue: 0.4) : Color.clear)
                )
        }
    }
}

// MARK: - Schedule Card (Upcoming)
struct ScheduleCard: View {
    let reservation: TicketReservation

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            mallImage

            VStack(alignment: .leading, spacing: 4) {
                Text(reservation.mallName)
                    .font(.subheadline.bold())
                Text(reservation.zone)
                    .font(.caption)
                    .foregroundColor(.blue)

                Label(reservation.date, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.gray)

                Label(reservation.timeRange, systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Starts in")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text("\(reservation.daysUntilStart ?? 0)")
                    .font(.title2.bold())
                Text("Days")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
        )
    }

    private var mallImage: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 72, height: 72)
            .overlay(
                Image(systemName: "building.2.fill")
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
}

// MARK: - History Card
struct HistoryCard: View {
    let reservation: TicketReservation

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                mallImage

                VStack(alignment: .leading, spacing: 4) {
                    Text(reservation.mallName)
                        .font(.subheadline.bold())
                    Text(reservation.zone)
                        .font(.caption)
                        .foregroundColor(.blue)

                    Label(reservation.date, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Label(reservation.timeRange, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                statusBadge
            }

            Divider()

            HStack {
                Text(reservation.isRefund ? "Refunded" : "Total Paid")
                    .font(.subheadline)
                Spacer()
                Text("\(reservation.isRefund ? "+" : "−") Rp. \(reservation.amount.formattedThousands())")
                    .font(.subheadline.bold())
                    .foregroundColor(reservation.isRefund ? .green : .primary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
        )
    }

    private var mallImage: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 72, height: 72)
            .overlay(
                Image(systemName: "building.2.fill")
                    .foregroundColor(.gray.opacity(0.5))
            )
    }

    private var statusBadge: some View {
        Text(reservation.status.label)
            .font(.caption2.bold())
            .foregroundColor(badgeTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(badgeBackgroundColor)
            )
    }

    private var badgeTextColor: Color {
        switch reservation.status {
        case .completed: return .green
        case .canceled: return .red
        case .upcoming: return .clear
        }
    }

    private var badgeBackgroundColor: Color {
        switch reservation.status {
        case .completed: return Color.green.opacity(0.15)
        case .canceled: return Color.red.opacity(0.15)
        case .upcoming: return .clear
        }
    }
}

extension Int {
    func formattedThousands() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
