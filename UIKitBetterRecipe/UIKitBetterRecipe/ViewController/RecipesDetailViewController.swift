import UIKit

class RecipesDetailViewController: UIViewController {
    var recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.setCustomSpacing(40, after: ingredientsLabel)
        return stackView
    }()

    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()

    //MARK: LifeCycle

    override func loadView() {
        super.loadView()
        setup()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

    }

    @objc func didTapFavorite() {
        recipe.isFavorite.toggle()
        let favImage = recipe.isFavorite ? "star.fill" : "star"
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: favImage)
    }
}

private extension RecipesDetailViewController {
    func setup() {
        let favIcon = UIImage(systemName: recipe.isFavorite ? "star.fill" : "star")
        self.navigationItem.title = "\(recipe.title)"
        let favBtn = UIBarButtonItem(
            image: favIcon,
            style: .plain,
            target: self,
            action: #selector(didTapFavorite)
        )
        favBtn.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItem = favBtn
        configure(with: recipe)
    }

    func configure(with recipe: Recipe) {
        titleLabel.text = recipe.title
        instructionLabel.text = recipe.instructions
        let ingr = recipe.ingredients.map{("- \($0)")}.joined(separator: "\n")
        ingredientsLabel.text = ingr
        

        self.view.addSubview(scrollView)

        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(ingredientsLabel)
        stackView.addArrangedSubview(instructionLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

}
