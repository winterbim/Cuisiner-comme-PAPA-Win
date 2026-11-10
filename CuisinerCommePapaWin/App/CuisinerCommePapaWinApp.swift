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
        #if DEBUG
        if let capture = CaptureScreen.current {
            CaptureScreenView(capture: capture, tabs: mainContent, selectedTab: $selectedTab)
        } else {
            mainContent
        }
        #else
        mainContent
        #endif
    }

    private var mainContent: some View {
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

#if DEBUG
// MARK: - Captures d'écran App Store (Debug uniquement, absent de la version publiée)

/// Écran ouvert directement au lancement : `-captureEcran accueil|recettes|fiche|favoris|profil|bienvenue`.
/// Utilisé par le workflow Codemagic « captures-ecran ».
enum CaptureScreen: String {
    case bienvenue, accueil, recettes, fiche, favoris, profil

    static var current: CaptureScreen? {
        UserDefaults.standard.string(forKey: "captureEcran").flatMap(CaptureScreen.init(rawValue:))
    }

    /// Recette affichée par la capture « fiche » (`-captureRecette ID`, Tajine Agneau Win par défaut).
    static var recipeID: String {
        UserDefaults.standard.string(forKey: "captureRecette") ?? "tajine-agneau-win"
    }
}

struct CaptureScreenView<Tabs: View>: View {
    @Environment(RecipeStore.self) private var recipeStore
    let capture: CaptureScreen
    let tabs: Tabs
    @Binding var selectedTab: AppTab

    var body: some View {
        switch capture {
        case .bienvenue:
            WelcomeView(onStart: {}, onDiscover: {})
        case .fiche:
            if let recipe = recipeStore.recipes.first(where: { $0.id == CaptureScreen.recipeID }) {
                NavigationStack { RecipeDetailView(recipe: recipe) }
            }
        case .accueil, .recettes, .favoris, .profil:
            tabs.onAppear {
                selectedTab = switch capture {
                case .recettes: .recipes
                case .favoris: .favorites
                case .profil: .profile
                default: .home
                }
            }
        }
    }
}
#endif
