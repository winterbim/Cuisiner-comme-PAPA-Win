import SwiftUI

/// Onglet « Mon profil » : nom de chef, grade, progression par cuisine.
struct ProfileView: View {
    @Environment(RecipeStore.self) private var store
    @Environment(CookbookStore.self) private var cookbook
    @AppStorage("chefName") private var chefName = ""
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = true
    @State private var confirmsReset = false

    var body: some View {
        let distinct = cookbook.distinctCooked(in: store.recipes)
        let level = CookbookStore.chefLevel(forDistinctCooked: distinct)

        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Carte de chef
                    VStack(spacing: 10) {
                        PapaWinAvatar(size: 130)
                        TextField("Ton nom de chef", text: $chefName)
                            .font(.papaTitle(26))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.red)
                            .submitLabel(.done)
                        Text("\(level.emoji) \(level.title)")
                            .font(.papaHand(18))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Theme.yellow, in: Capsule())
                        if let next = level.next {
                            Text("Encore \(next - distinct) plat\(next - distinct > 1 ? "s" : "") différent\(next - distinct > 1 ? "s" : "") pour monter en grade !")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Theme.inkSoft)
                                .multilineTextAlignment(.center)
                        } else {
                            Text("Tu as tout cuisiné. Papa Win te passe le tablier. 🏆")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Theme.inkSoft)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .papaCard(cornerRadius: 24)

                    // Statistiques
                    HStack(spacing: 10) {
                        StatTile(value: "\(cookbook.favoriteIDs.count)", title: "Favoris", emoji: "❤️")
                        StatTile(value: "\(distinct)/\(store.recipes.count)", title: "Plats testés", emoji: "🍽️")
                        StatTile(value: "\(cookbook.totalCooked)", title: "Fois aux fourneaux", emoji: "🔥")
                    }

                    // Progression par cuisine
                    VStack(alignment: .leading, spacing: 14) {
                        Text("🗺️ Mon tour du monde")
                            .font(.papaTitle(20))
                            .foregroundStyle(Theme.ink)
                        ForEach(Region.allCases) { region in
                            let recipes = store.recipes(in: region)
                            let done = cookbook.distinctCooked(in: recipes)
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("\(region.emoji) \(region.title)")
                                        .font(.subheadline.weight(.bold))
                                    Spacer()
                                    Text("\(done)/\(recipes.count)")
                                        .font(.subheadline.weight(.heavy))
                                        .monospacedDigit()
                                        .foregroundStyle(region.color)
                                }
                                ProgressView(value: Double(done), total: Double(max(recipes.count, 1)))
                                    .tint(region.color)
                            }
                        }
                    }
                    .padding(18)
                    .papaCard(cornerRadius: 20)

                    // Réglages
                    VStack(spacing: 12) {
                        Button {
                            hasSeenWelcome = false
                        } label: {
                            Label("Revoir l'écran d'accueil", systemImage: "sparkles")
                        }
                        .buttonStyle(SecondaryButtonStyle())

                        Button(role: .destructive) {
                            confirmsReset = true
                        } label: {
                            Text("Remettre ma progression à zéro")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(Theme.darkRed)
                        }
                    }

                    Text("Cuisiner comme Papa Win · \(store.recipes.count) plats salés, \(Region.allCases.count) cuisines, 0 dessert (Papa Win surveille sa ligne).")
                        .font(.caption)
                        .foregroundStyle(Theme.inkSoft)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding(16)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Mon profil")
            .scrollDismissesKeyboard(.interactively)
            .confirmationDialog("Effacer les plats cuisinés ?", isPresented: $confirmsReset, titleVisibility: .visible) {
                Button("Tout remettre à zéro", role: .destructive) {
                    cookbook.resetProgress()
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Tes favoris sont conservés.")
            }
        }
    }
}

private struct StatTile: View {
    let value: String
    let title: String
    let emoji: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.title2)
            Text(value)
                .font(.papaTitle(20))
                .foregroundStyle(Theme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 104)
        .padding(.vertical, 8)
        .papaCard(cornerRadius: 16)
    }
}
