import SwiftUI

/// Onglet Recettes : recherche, filtres par cuisine et filtres rapides.
struct RecipesView: View {
    @Environment(RecipeStore.self) private var store
    @State private var query = ""
    @State private var region: Region?
    @State private var filters: Set<QuickFilter> = []

    var body: some View {
        let results = store.filtered(query: query, region: region, filters: filters)
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    regionChips
                    filterChips

                    Text(results.count == 1 ? "1 recette" : "\(results.count) recettes")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.inkSoft)
                        .padding(.horizontal, 16)

                    if results.isEmpty {
                        PapaEmptyState(
                            title: "Rien dans la marmite…",
                            message: "Papa Win a fouillé tous les placards. Essaie un autre mot ou enlève un filtre !"
                        )
                    } else {
                        RecipeGrid(recipes: results)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 12)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Recettes")
            .searchable(text: $query, prompt: "Un plat, un ingrédient, un pays…")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }

    private var regionChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Toutes", emoji: "🍽️", isSelected: region == nil) {
                    region = nil
                }
                ForEach(Region.allCases) { item in
                    FilterChip(title: item.title, emoji: item.emoji, isSelected: region == item, color: item.color) {
                        region = (region == item) ? nil : item
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(QuickFilter.allCases) { filter in
                    FilterChip(title: filter.title, systemImage: filter.systemImage,
                               isSelected: filters.contains(filter), color: Theme.ink) {
                        if filters.contains(filter) {
                            filters.remove(filter)
                        } else {
                            filters.insert(filter)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
