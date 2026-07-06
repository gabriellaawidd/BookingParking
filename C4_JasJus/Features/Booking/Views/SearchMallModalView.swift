// MARK: - SearchMallModalView.swift
import SwiftUI
import Combine

struct SearchMallModalView: View {
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SearchMallViewModel()

    var body: some View {
        VStack(spacing: 0) {
            searchField

            HStack {
                Text(viewModel.sectionTitle)
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)

            resultsList

            Spacer()
        }
        .background(Color(.systemBackground))
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $viewModel.query)
            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
        .padding(.top, 16)
    }

    @ViewBuilder
    private var resultsList: some View {
        if viewModel.isLoading {
            ProgressView()
                .padding(.top, 40)
        } else if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .font(.caption)
                .padding()
        } else if viewModel.results.isEmpty {
            Text("Tidak ada mall ditemukan")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.top, 40)
        } else {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(viewModel.results) { mall in
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                router.push(.bookingDetails(mall))
                            }
                        } label: {
                            SearchMallRow(mall: mall)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 8)
            }
        }
    }
}
