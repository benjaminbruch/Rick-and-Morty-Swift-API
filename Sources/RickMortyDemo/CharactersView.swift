import SwiftUI
import RickMortySwiftApi

@MainActor
final class CharactersViewModel: ObservableObject {
    @Published var characters: [RMCharacterModel] = []
    @Published var isLoading = false

    private let client = RMClient()
    private var currentPage = 1
    private var canLoadMore = true

    func loadMoreIfNeeded(currentItem item: RMCharacterModel?) async {
        guard !isLoading && canLoadMore else { return }

        if item == nil {
            await loadPage()
            return
        }

        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if let item = item,
           let index = characters.firstIndex(where: { $0.id == item.id }),
           index >= thresholdIndex {
            await loadPage()
        }
    }

    private func loadPage() async {
        guard !isLoading && canLoadMore else { return }
        isLoading = true
        do {
            let newCharacters = try await client.character().getCharactersByPageNumber(pageNumber: currentPage)
            characters.append(contentsOf: newCharacters)
            currentPage += 1
        } catch NetworkHandlerError.RequestError {
            canLoadMore = false
        } catch {
            print("Error fetching characters: \(error)")
        }
        isLoading = false
    }
}

struct CharactersView: View {
    @StateObject private var viewModel = CharactersViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.characters) { character in
                    CharacterCardView(character: character)
                        .task { await viewModel.loadMoreIfNeeded(currentItem: character) }
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

struct CharacterCardView: View {
    let character: RMCharacterModel

    var body: some View {
        VStack {
            CachedImageView(url: URL(string: character.image))
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(character.name)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.windowBackgroundColor)))
        .shadow(radius: 2)
    }
}

#Preview {
    CharactersView()
}
