import SwiftUI

/// Onglet Accueil : Papa Win, le livre de recettes ouvert par cuisine et le plat du jour.
struct HomeView: View {
    @Environment(RecipeStore.self) private var store
    @Binding var selectedTab: AppTab

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header

                    if let error = store.loadError {
                        Text("Oups, Papa Win a renversé la marmite :\n\(error)")
                            .font(.footnote)
                            .foregroundStyle(Theme.darkRed)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
                    }

                    cookbook

                    if let recipe = store.recipeOfTheDay {
                        dishOfTheDay(recipe)
                    }

                    quickIdeas
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Theme.cream.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Region.self) { region in
                RegionView(region: region)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }

    // MARK: En-tête

    private var header: some View {
        VStack(spacing: 6) {
            Text("Cuisiner comme Papa Win")
                .font(.papaTitle(26))
                .foregroundStyle(Theme.red)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .padding(.top, 8)

            HStack(alignment: .center, spacing: 6) {
                PapaWinAvatar(size: 120)
                SpeechBubble(text: "Choisis une cuisine et régale toute la famille !")
                    .rotationEffect(.degrees(-2))
            }
        }
    }

    // MARK: Livre de recettes

    private var cookbook: some View {
        VStack(spacing: 14) {
            HStack {
                Text("📖 Mon livre de recettes")
                    .font(.papaTitle(22))
                    .foregroundStyle(Theme.ink)
                Spacer()
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Region.allCases) { region in
                    NavigationLink(value: region) {
                        RegionCard(region: region, recipes: store.recipes(in: region))
                    }
                    .buttonStyle(.plain)
                }
                totalSticker
            }
            .padding(12)
            .background(BookBackground())
        }
    }

    private var totalSticker: some View {
        Button {
            selectedTab = .recipes
        } label: {
            VStack(spacing: 2) {
                Text("\(store.recipes.count)")
                    .font(.papaTitle(44))
                    .foregroundStyle(Theme.red)
                Text("recettes\nau total")
                    .font(.papaHand(16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.ink)
                Text("Tout voir →")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(Theme.red)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 18)
            .background(Theme.yellow, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Theme.ink.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            )
            .rotationEffect(.degrees(-2))
        }
        .buttonStyle(.plain)
    }

    // MARK: Plat du jour

    private func dishOfTheDay(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("⭐️ Le plat du jour de Papa Win")
                .font(.papaTitle(22))
                .foregroundStyle(Theme.ink)

            NavigationLink(value: recipe) {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear
                        .frame(height: 190)
                        .frame(maxWidth: .infinity)
                        .overlay { RecipeImage(recipe: recipe, emojiSize: 84) }
                        .clipped()
                        .overlay(alignment: .topLeading) {
                            Text("\(recipe.flag) \(recipe.country)")
                                .font(.caption.weight(.bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.white.opacity(0.92), in: Capsule())
                                .padding(10)
                        }
                        .overlay(alignment: .topTrailing) {
                            FavoriteButton(recipe: recipe).padding(10)
                        }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(recipe.name)
                            .font(.papaTitle(24))
                            .foregroundStyle(Theme.red)
                        Text(recipe.pitch)
                            .font(.subheadline)
                            .foregroundStyle(Theme.ink)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 8) {
                            DifficultyBadge(difficulty: recipe.difficulty)
                            PillBadge(text: DurationFormatter.text(recipe.totalMinutes),
                                      systemImage: "clock.fill", color: Theme.ink, filled: false)
                            Spacer()
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Theme.red)
                        }
                    }
                    .padding(14)
                }
                .papaCard()
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Idées rapides

    private var quickIdeas: some View {
        let quick = store.recipes.filter { $0.difficulty == .facile }.prefix(10)
        return VStack(alignment: .leading, spacing: 10) {
            if !quick.isEmpty {
                Text("👍 Facile, même un lundi soir")
                    .font(.papaTitle(22))
                    .foregroundStyle(Theme.ink)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 14) {
                        ForEach(Array(quick)) { recipe in
                            NavigationLink(value: recipe) {
                                RecipeCard(recipe: recipe)
                                    .frame(width: 180)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

// MARK: - Carte région

struct RegionCard: View {
    let region: Region
    let recipes: [Recipe]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: [region.lightColor, region.color.opacity(0.75)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 70)
                Text(region.emoji)
                    .font(.system(size: 40))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 8)
                    .padding(.bottom, 12)
                Text(region.title)
                    .font(.papaTitle(17))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(region.color, in: Capsule())
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                ForEach(recipes.prefix(3)) { recipe in
                    HStack(spacing: 6) {
                        Circle().fill(region.color).frame(width: 6, height: 6)
                        Text(recipe.name)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                            .lineLimit(1)
                    }
                }
                Text("\(recipes.count) recettes →")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(region.color)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
        }
        .papaCard(cornerRadius: 16)
    }
}

/// Le livre ouvert : couverture marron, pages crème et marque-page rouge.
struct BookBackground: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Theme.bookCover)
                .shadow(color: Theme.ink.opacity(0.3), radius: 10, y: 6)
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.86))
                .padding(6)
            // Reliure au centre
            LinearGradient(colors: [.clear, Theme.ink.opacity(0.18), .clear],
                           startPoint: .leading, endPoint: .trailing)
                .frame(width: 22)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 6)
            // Marque-page
            BookmarkRibbon()
                .fill(Theme.red)
                .frame(width: 22, height: 44)
                .offset(x: -26, y: -6)
        }
    }
}

private struct BookmarkRibbon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.width * 0.45))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environment(RecipeStore())
        .environment(CookbookStore())
}
