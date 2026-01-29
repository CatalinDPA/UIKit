import UIKit

protocol RecipeCreateDelegate: AnyObject {
    func didAddRecipe(for recipe: Recipe)
}

class RecipeCreateViewController: UIViewController {

    var newRecipe: Recipe?
    weak var delegate: RecipeCreateDelegate?
    var ingredients: [String] = []

    //MARK: - UI

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
        stackView.setCustomSpacing(40, after: ingredientsText)
        return stackView
    }()

    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        return label
    }

    lazy var titleText: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Tortilla..."
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()

    lazy var ingredientsText: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Eggs..."
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .always
        return textField
    }()

    lazy var instructionText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        // textView.text = "Write the instructions!"
        textView.isScrollEnabled = false
        return textView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    lazy var ingrLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ingredients"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    lazy var ingrListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instructions"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    lazy var ingredientsBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("Add", comment: "Add an ingredient"), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
        btn.backgroundColor = .darkerGreen
        return btn
    }()

    lazy var titleRow: UIStackView = {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = 12
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleText.setContentHuggingPriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(titleLabel)
        row.addArrangedSubview(titleText)
        return row
    }()

    lazy var ingredientsRow: UIStackView = {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = 12
        ingrLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ingredientsText.setContentHuggingPriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(ingrLabel)
        row.addArrangedSubview(ingredientsText)
        row.addArrangedSubview(ingredientsBtn)
        return row
    }()

    lazy var instructionRow: UIStackView = {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .vertical
        row.spacing = 12
        row.addArrangedSubview(instructionLabel)
        row.addArrangedSubview(instructionText)
        return row
    }()
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Configuration
}

private extension RecipeCreateViewController {

    @objc func dissmis() {
        self.dismiss(animated: true, completion: nil)
    }

    func setup() {
        self.navigationItem.title = "Add a recipe"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let closeImage = UIImage(systemName: "xmark.circle.fill")
        let dismissBtn = UIBarButtonItem(
            image: closeImage,
            style: .plain,
            target: self,
            action: #selector(dissmis)
        )

        let addImage = UIImage(systemName: "plus.circle.fill")
        let addBtn = UIBarButtonItem(
            image: addImage,
            style: .plain,
            target: self ,
            action: #selector(didAddRecipe)
        )
        self.navigationItem.leftBarButtonItem = dismissBtn
        self.navigationItem.rightBarButtonItem = addBtn
        configure()
    }

    func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        ingredientsBtn
            .addTarget(
                self,
                action: #selector(addIngredient),
                for: .touchUpInside
            )

        stackView.addArrangedSubview(titleRow)
        stackView.addArrangedSubview(ingredientsRow)
        stackView.addArrangedSubview(ingrListLabel)
        stackView.addArrangedSubview(instructionRow)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            ingredientsBtn.widthAnchor.constraint(equalToConstant: 50),
            ingredientsBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

extension RecipeCreateViewController {

    @objc func didAddRecipe() {
        newRecipe = Recipe(
            title: titleText.text!,
            ingredients: ingredients,
            instructions: instructionText.text!,
            isFavorite: false
        )
        if let newRecipe = newRecipe {
            delegate?.didAddRecipe(for: newRecipe)
        }
        self.dismiss(animated: true, completion: nil)

    }

    @objc func addIngredient() {
        if !ingredientsText.text!.isEmpty {
            ingredients.append(ingredientsText.text ?? "")
            ingrListLabel.text = ingredients.map{("- \($0)")}.joined(separator: "\n")
            ingredientsText.text = ""
        }
    }
}

extension RecipeCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
}
