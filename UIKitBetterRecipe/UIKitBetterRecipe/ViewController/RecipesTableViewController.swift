import UIKit

class RecipesTableViewController: UIViewController {

    var filteredRecipeList: [Recipe] = Recipe.Data
    var defaultRecipeList: [Recipe]?
    var isFavSorted = false
    var onButtonTap: (() -> Void)?

    //MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView
            .register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.cellId)
        return tableView
    }()

    // MARK: LifeCycle

    override func loadView() {
        super.loadView()
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    //UIAlert

    let alert = UIAlertController(
        title: "Filter",
        message: "Filter by favorite",
        preferredStyle: .actionSheet
    )
}

private extension RecipesTableViewController {
    func setup() {
        tableView.delegate = self
        self.navigationController?.navigationBar.topItem?.title = "Better Recipes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addRecipe)
        )

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "shuffle.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(showAlert)
        )
        tableView.dataSource = self

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        alert
            .addAction(
                UIAlertAction(title: "Favorite Sort", style: .default, handler: {_ in
                    self.isFavSorted = true
                    self.filteredRecipeList = Recipe.Data.filter { recipe in
                        recipe.isFavorite
                    }
                    self.tableView.reloadData()
                })
            )

        alert
            .addAction(
                UIAlertAction(title: "Normal Sort", style: .default, handler: {_ in
                    self.isFavSorted = false
                    self.tableView.reloadData()
                })
            )
    }

    @objc func showAlert() {
        self.present(alert, animated: true, completion: nil)
    }

    @objc func addRecipe() {
        let addView = RecipeCreateViewController()
        addView.delegate = self
        let navigation = UINavigationController(rootViewController: addView)
        navigation.modalPresentationStyle = .pageSheet
        self.present(navigation, animated: true)
    }
}

// MARK: DataSource - Delegate
extension RecipesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFavSorted ? filteredRecipeList.count : Recipe.Data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = isFavSorted ? filteredRecipeList[indexPath.row] : Recipe.Data[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RecipeTableViewCell.cellId,
            for: indexPath
        ) as! RecipeTableViewCell
        cell.configure(with: recipe, delegate: self)
        cell.backgroundColor = indexPath.row % 2 == 0 ? .systemGray6 : .white
        return cell
    }

    // Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = Recipe.Data[indexPath.row]
        let recipesDetail = RecipesDetailViewController(recipe: recipe)
        navigationController?.pushViewController(recipesDetail, animated: true)
    }

    func deleteRecipe(withId id: Recipe.ID) {
        let index = Recipe.Data.getIndexRecipeById(withId: id)
            Recipe.Data.remove(at: index)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let id = isFavSorted ? filteredRecipeList[indexPath.row].id : Recipe.Data[indexPath.row].id
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "DeleteAction") { [weak self] _, _, completion in
                self?.deleteRecipe(withId: id)
                self?.tableView.reloadData()
                completion(false)
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension RecipesTableViewController: RecipeTableViewCellDelegate, RecipeCreateDelegate {
    func didAddRecipe(for recipe: Recipe) {
        Recipe.Data.append(recipe)
        tableView.reloadData()
    }

    func didTapFavorite(for recipe: Recipe) {
        recipe.isFavorite.toggle()
        tableView.reloadData()
    }
}

