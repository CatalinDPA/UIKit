import Foundation

class Recipe: Identifiable {
    var id: UUID = UUID()
    var title: String
    var ingredients: [String]
    var instructions: String
    var isFavorite: Bool

    init(
        title: String,
        ingredients: [String],
        instructions: String,
        isFavorite: Bool
    ) {
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.isFavorite = isFavorite
    }
}

extension [Recipe] {
    func getIndexRecipeById(withId id: Recipe.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id } ) else {
            fatalError("Id not found")
        }
        return index
    }

    func getRecipeById(withId id: Recipe.ID) -> Recipe {
        guard let recipe = first(where: { $0.id == id } ) else {
            fatalError("Id not found")
        }
        return recipe
    }
}

extension Recipe {
    static var Data = [
        Recipe(
            title: "Tortilla de Patatas",
            ingredients: ["Huevos", "Patatas", "Cebolla", "Aceite de oliva", "Sal"],
            instructions: "Freír las patatas con la cebolla, mezclar con el huevo batido y cuajar en la sartén por ambos lados.",
            isFavorite: false
        ),
        Recipe(
            title: "Guacamole Casero",
            ingredients: ["Aguacates", "Tomate", "Cebolla", "Lima", "Cilantro", "Sal"],
            instructions: "Machacar los aguacates y mezclar con los ingredientes picados finamente. Añadir zumo de lima al gusto.",
            isFavorite: false
        ),
        Recipe(
            title: "Pasta al Pesto",
            ingredients: ["Pasta", "Albahaca fresca", "Piñones", "Queso Parmesano", "Aceite de oliva"],
            instructions: "Cocer la pasta. Triturar la albahaca con los piñones, queso y aceite. Mezclar y servir.",
            isFavorite: true
        ),
        Recipe(
            title: "Pan con Tomate",
            ingredients: ["Pan", "Tomate maduro", "Aceite de oliva", "Sal", "Ajo"],
            instructions: "Tostar el pan, frotar el ajo y el tomate, y añadir un chorrito de aceite y sal.",
            isFavorite: false
        )
    ]
}
