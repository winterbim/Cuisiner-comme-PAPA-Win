import SwiftUI

/// Écran d'accueil affiché au premier lancement (inspiré de la maquette « Commencer »).
struct WelcomeView: View {
    @Environment(RecipeStore.self) private var store
    var onStart: () -> Void
    var onDiscover: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()
            Decorations()

            VStack(spacing: 14) {
                Spacer(minLength: 4)

                VStack(spacing: -4) {
                    Text("Cuisiner comme")
                        .font(.papaTitle(30))
                        .foregroundStyle(Theme.ink)
                    Text("Papa Win")
                        .font(.papaTitle(62))
                        .foregroundStyle(Theme.red)
                        .shadow(color: .white, radius: 0, x: 3, y: 3)
                        .shadow(color: Theme.ink.opacity(0.25), radius: 0, x: 4, y: 5)
                }
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

                Text("Des recettes revisitées avec humour")
                    .font(.papaHand(17))
                    .foregroundStyle(Theme.ink)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(Theme.yellow, in: Capsule())
                    .rotationEffect(.degrees(-3))

                PapaWinAvatar(size: 230)
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)
                    .padding(.top, 8)

                Text("\(store.recipes.count) plats salés · \(Region.allCases.count) cuisines · 0 dessert")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Theme.inkSoft)

                Spacer(minLength: 4)

                Button(action: onStart) {
                    HStack {
                        Text("Commencer")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())

                Button(action: onDiscover) {
                    Label("Découvrir les recettes", systemImage: "book")
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.7, bounce: 0.45).delay(0.15)) {
                appeared = true
            }
        }
    }
}

/// Petits ingrédients qui flottent autour, comme sur la maquette.
private struct Decorations: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                decoration("🍅", size: 34, x: w * 0.88, y: h * 0.30, angle: 12)
                decoration("🌿", size: 30, x: w * 0.10, y: h * 0.36, angle: -20)
                decoration("🌶️", size: 26, x: w * 0.12, y: h * 0.58, angle: 25)
                decoration("🧄", size: 28, x: w * 0.88, y: h * 0.58, angle: -8)
                decoration("🫒", size: 24, x: w * 0.90, y: h * 0.08, angle: 0)
                decoration("🍋", size: 26, x: w * 0.08, y: h * 0.10, angle: -15)
                decoration("✨", size: 22, x: w * 0.20, y: h * 0.22, angle: 0)
                decoration("✨", size: 18, x: w * 0.80, y: h * 0.44, angle: 0)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private func decoration(_ emoji: String, size: CGFloat, x: CGFloat, y: CGFloat, angle: Double) -> some View {
        Text(emoji)
            .font(.system(size: size))
            .rotationEffect(.degrees(angle))
            .position(x: x, y: y)
            .opacity(0.9)
    }
}

#Preview {
    WelcomeView(onStart: {}, onDiscover: {})
        .environment(RecipeStore())
}
