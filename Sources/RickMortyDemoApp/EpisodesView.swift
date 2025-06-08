import SwiftUI
import RickMortySwiftApi

struct EpisodesView: View {
    @State private var episodes: [RMEpisodeModel] = []
    @State private var isLoading = true
    private let client = RMClient()

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    List(episodes) { episode in
                        EpisodeCard(episode: episode)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Episodes")
        }
        .task {
            await loadEpisodes()
        }
    }

    private func loadEpisodes() async {
        do {
            episodes = try await client.episode().getAllEpisodes()
        } catch {
            print("Error fetching episodes: \(error)")
        }
        isLoading = false
    }
}

struct EpisodeCard: View {
    let episode: RMEpisodeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.name)
                .font(.headline)
            Text(episode.episode)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(episode.airDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(radius: 2))
    }
}

#Preview {
    EpisodesView()
}
