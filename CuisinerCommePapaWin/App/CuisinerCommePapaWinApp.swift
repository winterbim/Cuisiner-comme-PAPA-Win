import SwiftUI

@main
struct CuisinerCommePapaWinApp: App {
    @State private var recipeStore = RecipeStore()
    @State private var cookbook = CookbookStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(recipeStore)
                .environment(cookbook)
                .tint(Theme.red)
                .preferredColorScheme(.light)
        }
    }
}

enum AppTab: Hashable {
    case home, recipes, favorites, profile
}

struct RootView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem { Label("Accueil", systemImage: "house.fill") }
                .tag(AppTab.home)

            RecipesView()
                .tabItem { Label("Recettes", systemImage: "book.fill") }
                .tag(AppTab.recipes)

            FavoritesView(selectedTab: $selectedTab)
                .tabItem { Label("Favoris", systemImage: "heart.fill") }
                .tag(AppTab.favorites)

            ProfileView()
                .tabItem { Label("Mon profil", systemImage: "person.crop.circle.fill") }
                .tag(AppTab.profile)
        }
        .toolbarBackground(Theme.paper, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .fullScreenCover(isPresented: Binding(get: { !hasSeenWelcome },
                                              set: { hasSeenWelcome = !$0 })) {
            WelcomeView(
                onStart: {
                    selectedTab = .home
                    hasSeenWelcome = true
                },
                onDiscover: {
                    selectedTab = .recipes
                    hasSeenWelcome = true
                }
            )
        }
    }
}
