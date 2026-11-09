import SwiftUI

/// Les recettes d'une cuisine (Portugal, Asie, Afrique, Maghreb, France).
struct RegionView: View {
    @Environment(RecipeStore.self) private var store
    let region: Region

    var body: some View {
        let recipes = store.recipes(in: region)
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .center, spacing: 14) {
                    Text(region.emoji)
                        .font(.system(size: 58))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(region.title)
                            .font(.papaTitle(34))
                            .foregroundStyle(.white)
                        Text(region.tagline)
                            .font(.papaHand(15))
                            .foregroundStyle(.white.opacity(0.95))
                        Text("\(recipes.count) recettes Win")
                            .font(.caption.weight(.heavy))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.white, in: Capsule())
                            .foregroundStyle(region.color)
                            .padding(.top, 4)
                    }
                    Spacer(minLength: 0)
                }
                .padding(18)
                .background(
                    LinearGradient(colors: [region.color, region.color.opacity(0.75)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous)
                )
                .shadow(color: region.color.opacity(0.35), radius: 10, y: 6)

                RecipeGrid(recipes: recipes)
            }
            .padding(16)
        }
        .background(Theme.cream.ignoresSafeArea())
        .navigationTitle(region.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
