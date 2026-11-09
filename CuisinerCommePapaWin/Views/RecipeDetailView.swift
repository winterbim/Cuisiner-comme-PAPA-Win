import SwiftUI
import UIKit

/// Fiche recette : photo, infos, ingrédients ajustables, étapes à cocher et astuce de Papa Win.
struct RecipeDetailView: View {
    @Environment(CookbookStore.self) private var cookbook
    let recipe: Recipe

    @State private var servings: Int
    @State private var checkedIngredients: Set<Int> = []
    @State private var doneSteps: Set<Int> = []
    @State private var showsCelebration = false

    init(recipe: Recipe) {
        self.recipe = recipe
        _servings = State(initialValue: recipe.servings)
    }

    private var scale: Double {
        Double(servings) / Double(max(recipe.servings, 1))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                hero

                VStack(alignment: .leading, spacing: 24) {
                    titleBlock
                    timeTiles
                    ingredientsSection
                    stepsSection
                    PapaTipCard(tip: recipe.tip)
                    cookedButton
                }
                .padding(20)
                .padding(.bottom, 20)
                .background(
                    Theme.cream,
                    in: UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28, style: .continuous)
                )
                .offset(y: -28)
                .padding(.bottom, -28)
            }
        }
        .background(Theme.cream.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ShareLink(item: recipe.shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Theme.ink)
                        .padding(7)
                        .background(.white.opacity(0.92), in: Circle())
                }
                FavoriteButton(recipe: recipe, compact: true)
            }
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
        .alert("Bravo chef ! 🎉", isPresented: $showsCelebration) {
            Button("Merci Papa Win !", role: .cancel) {}
        } message: {
            Text(celebrationMessage)
        }
    }

    // MARK: Sections

    private var hero: some View {
        Color.clear
            .frame(height: 320)
            .frame(maxWidth: .infinity)
            .overlay { RecipeImage(recipe: recipe, emojiSize: 120) }
            .overlay(alignment: .top) {
                LinearGradient(colors: [.black.opacity(0.25), .clear], startPoint: .top, endPoint: .bottom)
                    .frame(height: 110)
            }
            .clipped()
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recipe.name)
                .font(.papaTitle(34))
                .foregroundStyle(Theme.red)
            Text("\(recipe.flag) \(recipe.originalName) · \(recipe.country)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.inkSoft)

            FlowBadges(recipe: recipe)

            Text("« \(recipe.pitch) »")
                .font(.papaHand(17))
                .foregroundStyle(Theme.ink)
                .padding(.top, 4)
        }
    }

    private var timeTiles: some View {
        HStack(spacing: 10) {
            InfoTile(title: "Préparation", value: DurationFormatter.text(recipe.prepMinutes), systemImage: "hand.raised.fill")
            InfoTile(title: "Cuisson", value: DurationFormatter.text(recipe.cookMinutes), systemImage: "flame.fill")
            InfoTile(title: "Total", value: DurationFormatter.text(recipe.totalMinutes), systemImage: "clock.fill")
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SectionTitle(text: "Ingrédients", emoji: "🧺")
                Spacer()
                servingsStepper
            }

            VStack(spacing: 0) {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                    IngredientRow(ingredient: ingredient, scale: scale,
                                  isChecked: checkedIngredients.contains(index)) {
                        toggle(index, in: $checkedIngredients)
                    }
                    if index < recipe.ingredients.count - 1 {
                        Divider().padding(.leading, 44)
                    }
                }
            }
            .padding(.vertical, 4)
            .papaCard(cornerRadius: 18)
        }
    }

    private var servingsStepper: some View {
        HStack(spacing: 4) {
            Button {
                if servings > 1 { servings -= 1 }
            } label: {
                Image(systemName: "minus")
                    .frame(width: 30, height: 30)
            }
            .disabled(servings <= 1)

            Text("\(servings) pers.")
                .font(.subheadline.weight(.heavy))
                .monospacedDigit()
                .frame(minWidth: 58)

            Button {
                if servings < 20 { servings += 1 }
            } label: {
                Image(systemName: "plus")
                    .frame(width: 30, height: 30)
            }
            .disabled(servings >= 20)
        }
        .font(.subheadline.weight(.bold))
        .foregroundStyle(Theme.ink)
        .padding(.horizontal, 4)
        .background(Theme.lightYellow, in: Capsule())
        .overlay(Capsule().stroke(Theme.yellow, lineWidth: 1.5))
        .sensoryFeedback(.increase, trigger: servings)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Nombre de personnes")
        .accessibilityValue("\(servings)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: if servings < 20 { servings += 1 }
            case .decrement: if servings > 1 { servings -= 1 }
            @unknown default: break
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(text: "Étapes", emoji: "👨‍🍳")
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                StepRow(number: index + 1, text: step, isDone: doneSteps.contains(index)) {
                    toggle(index, in: $doneSteps)
                }
            }
        }
    }

    private var cookedButton: some View {
        VStack(spacing: 8) {
            Button {
                cookbook.markCooked(recipe)
                showsCelebration = true
            } label: {
                Label("J'ai cuisiné ce plat !", systemImage: "checkmark.seal.fill")
            }
            .buttonStyle(PrimaryButtonStyle())
            .sensoryFeedback(.success, trigger: cookbook.timesCooked(recipe))

            let count = cookbook.timesCooked(recipe)
            if count > 0 {
                Text(count == 1 ? "Tu l'as déjà cuisiné 1 fois" : "Tu l'as déjà cuisiné \(count) fois")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Theme.inkSoft)
            }
        }
    }

    private var celebrationMessage: String {
        let messages = [
            "Papa Win est fier de toi. Ce soir, c'est toi le chef de la maison !",
            "Les assiettes vont revenir vides, c'est garanti sur facture.",
            "Un plat de plus dans ton palmarès. La famille t'applaudit !",
            "Attention, à ce rythme tu vas piquer le tablier de Papa Win.",
        ]
        return messages[cookbook.timesCooked(recipe) % messages.count]
    }

    /// Coche / décoche dans la transaction animée (Binding, pour que l'état change pendant l'animation).
    private func toggle(_ index: Int, in set: Binding<Set<Int>>) {
        withAnimation(.easeInOut(duration: 0.2)) {
            set.wrappedValue.formSymmetricDifference([index])
        }
    }
}

// MARK: - Sous-vues

private struct FlowBadges: View {
    let recipe: Recipe

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                DifficultyBadge(difficulty: recipe.difficulty)
                ForEach(recipe.recipeTags) { tag in
                    TagBadge(tag: tag)
                }
            }
        }
    }
}

private struct SectionTitle: View {
    let text: String
    let emoji: String

    var body: some View {
        HStack(spacing: 8) {
            Text(emoji)
            Text(text)
        }
        .font(.papaTitle(22))
        .foregroundStyle(Theme.ink)
    }
}

private struct InfoTile: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.subheadline)
                .foregroundStyle(Theme.red)
            Text(value)
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(Theme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Theme.inkSoft)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .papaCard(cornerRadius: 16)
    }
}

private struct IngredientRow: View {
    let ingredient: Ingredient
    let scale: Double
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isChecked ? Theme.green : Theme.ink.opacity(0.3))
                    .frame(width: 22)
                VStack(alignment: .leading, spacing: 2) {
                    if let quantity = ingredient.quantityText(scale: scale) {
                        Text(quantity)
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(isChecked ? Theme.inkSoft : Theme.red)
                    }
                    Text(ingredient.name)
                        .font(.body)
                        .strikethrough(isChecked)
                        .foregroundStyle(isChecked ? Theme.inkSoft : Theme.ink)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isChecked ? .isSelected : [])
    }
}

private struct StepRow: View {
    let number: Int
    let text: String
    let isDone: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle().fill(isDone ? Theme.green : Theme.red)
                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.subheadline.weight(.heavy))
                    } else {
                        Text("\(number)")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                    }
                }
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)

                Text(text)
                    .font(.body)
                    .foregroundStyle(isDone ? Theme.inkSoft : Theme.ink)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .papaCard(cornerRadius: 16)
            .opacity(isDone ? 0.7 : 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Étape \(number) : \(text)")
        .accessibilityAddTraits(isDone ? .isSelected : [])
    }
}

/// L'encadré « L'astuce de Papa Win ».
struct PapaTipCard: View {
    let tip: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            PapaWinAvatar(size: 74, showsHat: false)
            VStack(alignment: .leading, spacing: 6) {
                Text("L'astuce de Papa Win")
                    .font(.papaHand(19))
                    .foregroundStyle(Theme.red)
                Text(tip)
                    .font(.callout)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.lightYellow, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Theme.yellow, style: StrokeStyle(lineWidth: 2, dash: [7, 5]))
        )
    }
}
