#if canImport(SwiftUI)
import SwiftUI
import RickMortySwiftApi

@MainActor
final class EpisodesViewModel: ObservableObject {
    @Published var episodes: [RMEpisodeModel] = []
    @Published var isLoading = false

    private let client = RMClient()
    private var currentPage = 1
    private var canLoadMore = true
    private var cache: [Int: [RMEpisodeModel]] = [:]

    func loadMoreIfNeeded(currentItem item: RMEpisodeModel?) async {
        guard !isLoading && canLoadMore else { return }

        if item == nil {
            await loadPage()
            return
        }

        let thresholdIndex = episodes.index(episodes.endIndex, offsetBy: -5)
        if let item = item,
           let index = episodes.firstIndex(where: { $0.id == item.id }),
           index >= thresholdIndex {
            await loadPage()
        }
    }

    private func loadPage() async {
        guard !isLoading && canLoadMore else { return }

        if let cached = cache[currentPage] {
            episodes.append(contentsOf: cached)
            currentPage += 1
            return
        }

        isLoading = true
        do {
            let newEpisodes = try await client.episode().getEpisodesByPageNumber(pageNumber: currentPage)
            cache[currentPage] = newEpisodes
            episodes.append(contentsOf: newEpisodes)
            currentPage += 1
        } catch NetworkHandlerError.RequestError {
            canLoadMore = false
        } catch {
            print("Error fetching episodes: \(error)")
        }
        isLoading = false
    }
}

struct EpisodesView: View {
    @StateObject private var viewModel = EpisodesViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.episodes) { episode in
                    EpisodeCardView(episode: episode)
                        .task { await viewModel.loadMoreIfNeeded(currentItem: episode) }
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

struct EpisodeCardView: View {
    let episode: RMEpisodeModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.name)
                .font(.headline)
            Text(episode.episode)
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
    EpisodesView()
}
#endif
