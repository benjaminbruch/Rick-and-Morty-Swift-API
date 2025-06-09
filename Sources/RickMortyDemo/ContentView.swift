#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CharactersView()
                .tabItem { Label("Characters", systemImage: "person.3.fill") }
            EpisodesView()
                .tabItem { Label("Episodes", systemImage: "film.fill") }
            LocationsView()
                .tabItem { Label("Locations", systemImage: "map.fill") }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    ContentView()
}
#endif
