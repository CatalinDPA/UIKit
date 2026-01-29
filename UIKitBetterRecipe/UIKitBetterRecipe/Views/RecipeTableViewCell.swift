import UIKit

protocol RecipeTableViewCellDelegate: AnyObject {
    func didTapFavorite(for recipe: Recipe)
}

class RecipeTableViewCell: UITableViewCell {
    static let cellId = "RecipeTableViewCell"
    // MARK: - UI

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var favoriteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemYellow
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()

    // MARK: LifeCycle

    private weak var delegate: RecipeTableViewCellDelegate?
    private var recipe: Recipe?


    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
    }



    func configure(with recipe: Recipe, delegate: RecipeTableViewCellDelegate) {
        self.delegate = delegate
        self.recipe = recipe
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)

        favoriteButton.setImage(UIImage(systemName: recipe.isFavorite ? "star.fill" : "star"), for: .normal)
        descriptionLabel.text = "Click to see more!"
        titleLabel.text = recipe.title

        self.contentView.addSubview(containerView)
        containerView.addSubview(contentStackView)
        containerView.addSubview(favoriteButton)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor
                .constraint(equalTo: self.contentView.topAnchor, constant: 16),
            containerView.bottomAnchor
                .constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            containerView.leadingAnchor
                .constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            containerView.trailingAnchor
                .constraint(equalTo: self.contentView.trailingAnchor, constant: -8),

            contentStackView.topAnchor
                .constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStackView.bottomAnchor
                .constraint(equalTo: containerView.bottomAnchor, constant: -16),
            contentStackView.leadingAnchor
                .constraint(equalTo: containerView.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor, constant: -8),

            favoriteButton.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor, constant: -8),
        ])

    }
    @objc func didTapFavorite() {
        if let recipe = recipe {
            delegate?.didTapFavorite(for: recipe)
        }
    }
}
