import UIKit
import XCTest
@testable import CuisinerCommePapaWin

/// Tests unitaires de l'app, exécutés dans le simulateur (app hôte).
/// Lancement : Xcode ⌘U, ou `xcodebuild test -scheme CuisinerCommePapaWin -destination …`.
final class RecipeDataTests: XCTestCase {
    private var store: RecipeStore!

    override func setUp() {
        super.setUp()
        store = RecipeStore(bundle: Bundle(for: RecipeStore.self))
    }

    func testLes75RecettesSeChargentSansErreur() {
        XCTAssertNil(store.loadError, store.loadError ?? "")
        XCTAssertEqual(store.recipes.count, 75)
    }

    func testQuinzeRecettesParCuisine() {
        for region in Region.allCases {
            XCTAssertEqual(store.recipes(in: region).count, 15, "Cuisine \(region.title)")
        }
    }

    func testIdentifiantsUniquesEtNomsWin() {
        let ids = store.recipes.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "Identifiants en double")
        for recipe in store.recipes {
            XCTAssertTrue(recipe.name.contains("Win"), "\(recipe.id) : « Win » absent du nom")
            XCTAssertFalse(recipe.ingredients.isEmpty, recipe.id)
            XCTAssertGreaterThanOrEqual(recipe.steps.count, 4, recipe.id)
            XCTAssertFalse(recipe.tip.isEmpty, recipe.id)
            XCTAssertGreaterThan(recipe.servings, 0, recipe.id)
            XCTAssertEqual(recipe.recipeTags.count, recipe.tags.count, "\(recipe.id) : étiquette inconnue")
        }
    }

    func testLokWinEstAuPoulet() throws {
        let lok = try XCTUnwrap(store.recipes.first { $0.id == "lok-win" })
        XCTAssertEqual(lok.region, .asie)
        XCTAssertTrue(lok.ingredients.contains { $0.name.localizedCaseInsensitiveContains("poulet") })
        XCTAssertFalse(lok.ingredients.contains { $0.name.localizedCaseInsensitiveContains("bœuf") })
    }

    func testRecettesRapidesEnTrenteMinutesMaximum() {
        for recipe in store.recipes where recipe.recipeTags.contains(.rapide) {
            XCTAssertLessThanOrEqual(recipe.totalMinutes, 30, recipe.id)
        }
    }

    func testRecherche() {
        XCTAssertFalse(store.filtered(query: "poulet", region: nil, filters: []).isEmpty)
        // Accents ignorés : « tchebou » trouve « Tchébou Win », « pho » trouve « Phở Win ».
        XCTAssertTrue(store.filtered(query: "tchebou", region: nil, filters: []).contains { $0.id == "tchebou-win" })
        XCTAssertTrue(store.filtered(query: "pho", region: nil, filters: []).contains { $0.id == "pho-win" })
        XCTAssertTrue(store.filtered(query: "zzz-introuvable", region: nil, filters: []).isEmpty)
    }

    func testFiltres() {
        let asie = store.filtered(query: "", region: .asie, filters: [])
        XCTAssertEqual(asie.count, 15)
        let faciles = store.filtered(query: "", region: nil, filters: [.facile])
        XCTAssertTrue(faciles.allSatisfy { $0.difficulty == .facile })
        let vegetariens = store.filtered(query: "", region: nil, filters: [.vegetarien])
        XCTAssertTrue(vegetariens.allSatisfy { $0.recipeTags.contains(.vegetarien) })
    }

    func testPlatDuJour() {
        XCTAssertNotNil(store.recipeOfTheDay)
    }

    func testTexteDePartage() throws {
        let recipe = try XCTUnwrap(store.recipes.first)
        XCTAssertTrue(recipe.shareText.contains(recipe.name))
        XCTAssertTrue(recipe.shareText.contains(recipe.tip))
    }
}

final class FormatterTests: XCTestCase {
    func testQuantites() {
        XCTAssertEqual(QuantityFormatter.format(600), "600")
        XCTAssertEqual(QuantityFormatter.format(152), "150")
        XCTAssertEqual(QuantityFormatter.format(12.4), "12")
        XCTAssertEqual(QuantityFormatter.format(0.5), "½")
        XCTAssertEqual(QuantityFormatter.format(0.75), "¾")
        XCTAssertEqual(QuantityFormatter.format(1.5), "1½")
        XCTAssertEqual(QuantityFormatter.format(2.25), "2¼")
        XCTAssertEqual(QuantityFormatter.format(0.1), "0,1")
    }

    func testIngredientAdapteAuxPortions() {
        let riz = Ingredient(quantity: 300, unit: "g", name: "riz")
        XCTAssertEqual(riz.quantityText(scale: 2), "600 g")
        let oignons = Ingredient(quantity: 2, unit: nil, name: "oignons")
        XCTAssertEqual(oignons.quantityText(scale: 0.5), "1")
        let sel = Ingredient(quantity: nil, unit: nil, name: "sel")
        XCTAssertNil(sel.quantityText(scale: 3))
    }

    func testKiloEtLitreEnDecimales() {
        let agneau = Ingredient(quantity: 1.2, unit: "kg", name: "épaule d'agneau")
        XCTAssertEqual(agneau.quantityText(scale: 1), "1,2 kg")
        XCTAssertEqual(agneau.quantityText(scale: 0.5), "0,6 kg")
        XCTAssertEqual(agneau.quantityText(scale: 2.5), "3 kg")
        let bouillon = Ingredient(quantity: 1.2, unit: "l", name: "bouillon")
        XCTAssertEqual(bouillon.quantityText(scale: 7.0 / 6.0), "1,4 l")
        // Les autres unités gardent les fractions.
        let miel = Ingredient(quantity: 2, unit: "c. à soupe", name: "miel")
        XCTAssertEqual(miel.quantityText(scale: 1.25), "2½ c. à soupe")
    }

    func testDurees() {
        XCTAssertEqual(DurationFormatter.text(45), "45 min")
        XCTAssertEqual(DurationFormatter.text(60), "1 h")
        XCTAssertEqual(DurationFormatter.text(65), "1 h 05")
        XCTAssertEqual(DurationFormatter.text(150), "2 h 30")
    }
}

final class CookbookStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private var recipe: Recipe!

    override func setUp() {
        super.setUp()
        suiteName = "tests.papawin.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        recipe = RecipeStore(bundle: Bundle(for: RecipeStore.self)).recipes.first
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testFavorisSauvegardes() throws {
        let recipe = try XCTUnwrap(recipe)
        let store = CookbookStore(defaults: defaults)
        XCTAssertFalse(store.isFavorite(recipe))
        store.toggleFavorite(recipe)
        XCTAssertTrue(store.isFavorite(recipe))
        XCTAssertTrue(CookbookStore(defaults: defaults).isFavorite(recipe), "Le favori doit survivre au redémarrage")
        store.toggleFavorite(recipe)
        XCTAssertFalse(CookbookStore(defaults: defaults).isFavorite(recipe))
    }

    func testPlatsCuisinesEtRemiseAZero() throws {
        let recipe = try XCTUnwrap(recipe)
        let store = CookbookStore(defaults: defaults)
        store.markCooked(recipe)
        store.markCooked(recipe)
        XCTAssertEqual(store.timesCooked(recipe), 2)
        XCTAssertEqual(CookbookStore(defaults: defaults).timesCooked(recipe), 2)
        XCTAssertEqual(store.distinctCooked(in: [recipe]), 1)
        store.resetProgress()
        XCTAssertEqual(store.totalCooked, 0)
        XCTAssertEqual(CookbookStore(defaults: defaults).totalCooked, 0)
    }

    func testGradesDeChef() {
        XCTAssertEqual(CookbookStore.chefLevel(forDistinctCooked: 0).title, "Apprenti Win")
        XCTAssertEqual(CookbookStore.chefLevel(forDistinctCooked: 1).title, "Commis Win")
        XCTAssertEqual(CookbookStore.chefLevel(forDistinctCooked: 5).title, "Chef Win")
        XCTAssertEqual(CookbookStore.chefLevel(forDistinctCooked: 15).title, "Grand Chef Win")
        XCTAssertEqual(CookbookStore.chefLevel(forDistinctCooked: 30).title, "Maître Win")
        let last = CookbookStore.chefLevel(forDistinctCooked: 75)
        XCTAssertEqual(last.title, "Papa Win légendaire")
        XCTAssertNil(last.next)
    }
}

final class AssetCatalogTests: XCTestCase {
    func testMascotteDansLeBundle() {
        for name in [MascotAsset.original, MascotAsset.fullHD, MascotAsset.round] {
            XCTAssertNotNil(UIImage(named: name), "Image de mascotte absente du bundle : \(name)")
        }
        XCTAssertEqual(MascotAsset.firstAvailable([MascotAsset.round, MascotAsset.original]), MascotAsset.round)
    }

    func testCouleurDAccent() {
        XCTAssertNotNil(UIColor(named: "AccentColor"))
    }

    /// Informatif : la couverture complète des 75 illustrations est contrôlée par scripts/validate_assets.py.
    func testImagesDeRecettesCompileesDansLeBundle() {
        let store = RecipeStore(bundle: Bundle(for: RecipeStore.self))
        let present = store.recipes.filter { UIImage(named: $0.imageName) != nil }
        print("Illustrations de recettes présentes dans le bundle : \(present.count)/\(store.recipes.count)")
        XCTAssertGreaterThan(present.count, 0, "Le catalogue d'images n'est pas compilé dans l'app")
    }
}
