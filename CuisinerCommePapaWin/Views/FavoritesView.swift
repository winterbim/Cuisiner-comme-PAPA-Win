import SwiftUI

/// Onglet Favoris : les plats que tu as mis de côté avec le ❤️.
struct FavoritesView: View {
    @Environment(RecipeStore.self) private var store
    @Environment(CookbookStore.self) private var cookbook
    @Binding var selectedTab: AppTab

    var body: some View {
        let favorites = store.recipes.filter { cookbook.favoriteIDs.contains($0.id) }
        NavigationStack {
            ScrollView {
                if favorites.isEmpty {
                    VStack(spacing: 18) {
                        PapaEmptyState(
                            title: "Pas encore de favoris",
                            message: "Appuie sur le ❤️ d'une recette et Papa Win la gardera bien au chaud ici."
                        )
                        Button {
                            selectedTab = .recipes
                        } label: {
                            Label("Trouver un plat", systemImage: "magnifyingglass")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                    .padding(.top, 40)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(favorites.count == 1 ? "1 plat chouchou" : "\(favorites.count) plats chouchous")
                            .font(.papaHand(17))
                            .foregroundStyle(Theme.inkSoft)
                        RecipeGrid(recipes: favorites)
                    }
                    .padding(16)
                }
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Favoris")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}
