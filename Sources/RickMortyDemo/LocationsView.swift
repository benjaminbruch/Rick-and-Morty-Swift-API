#if canImport(SwiftUI)
import SwiftUI
import RickMortySwiftApi

@MainActor
final class LocationsViewModel: ObservableObject {
    @Published var locations: [RMLocationModel] = []
    @Published var isLoading = false

    private let client = RMClient()
    private var currentPage = 1
    private var canLoadMore = true
    private var cache: [Int: [RMLocationModel]] = [:]

    func loadMoreIfNeeded(currentItem item: RMLocationModel?) async {
        guard !isLoading && canLoadMore else { return }

        if item == nil {
            await loadPage()
            return
        }

        let thresholdIndex = locations.index(locations.endIndex, offsetBy: -5)
        if let item = item,
           let index = locations.firstIndex(where: { $0.id == item.id }),
           index >= thresholdIndex {
            await loadPage()
        }
    }

    private func loadPage() async {
        guard !isLoading && canLoadMore else { return }

        if let cached = cache[currentPage] {
            locations.append(contentsOf: cached)
            currentPage += 1
            return
        }

        isLoading = true
        do {
            let newLocations = try await client.location().getLocationsByPageNumber(pageNumber: currentPage)
            cache[currentPage] = newLocations
            locations.append(contentsOf: newLocations)
            currentPage += 1
        } catch NetworkHandlerError.RequestError {
            canLoadMore = false
        } catch {
            print("Error fetching locations: \(error)")
        }
        isLoading = false
    }
}

struct LocationsView: View {
    @StateObject private var viewModel = LocationsViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.locations) { location in
                    LocationCardView(location: location)
                        .task { await viewModel.loadMoreIfNeeded(currentItem: location) }
                }
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding(16)
        }
        .task { await viewModel.loadMoreIfNeeded(currentItem: nil) }
    }
}

struct LocationCardView: View {
    let location: RMLocationModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.headline)
            Text(location.dimension)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 150, height: 80)
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.windowBackgroundColor)))
        .shadow(radius: 2)
    }
}
#Preview {
    LocationsView()
}
#endif
