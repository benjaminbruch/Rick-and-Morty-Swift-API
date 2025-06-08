import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CharactersView()
                .tabItem {
                    Label("Characters", systemImage: "person.3.fill")
                }
            EpisodesView()
                .tabItem {
                    Label("Episodes", systemImage: "tv.fill")
                }
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "map.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
