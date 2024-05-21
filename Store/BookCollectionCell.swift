import UIKit

final class BookCollectionCell: UICollectionViewCell {
    public static var reuseIdentifier: String {String(describing: self)}
    private var isBookInCart = false {
        didSet { addButton.setNeedsUpdateConfiguration() }
    }
    private var showAddButton = true {
        didSet { addButton.isHidden = !showAddButton }
    }
    private var didTapCartButton: (() -> Bool)?
    private var book: Book? {
        didSet { self.configUI() }
    }
    private let coverView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private let textStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .equalCentering
        $0.alignment = .leading
        return $0
    }(UIStackView())

    private let titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        return $0
    }(UILabel())

    private let subtitleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        return $0
    }(UILabel())

    private lazy var addButton: UIButton = {
        var config = UIButton.Configuration.gray()
        $0.configuration = config
        $0.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            let symbolName = self.isBookInCart ? "cart.badge.minus" : "cart.badge.plus"
            config?.image = UIImage(systemName: symbolName)
            button.configuration = config
        }
        $0.addAction(UIAction { _ in
            if let inChart = self.didTapCartButton?() {
                self.isBookInCart = inChart
            }
        },
            for: .primaryActionTriggered
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageWidthRatio = traitCollection.userInterfaceIdiom == .pad ? 0.125 : 0.25
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            coverView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: imageWidthRatio),

            textStackView.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 10),
            textStackView.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            textStackView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),

            addButton.centerYAnchor.constraint(equalTo: coverView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }

    private func setupViews() {
        [coverView, textStackView, addButton]
            .forEach { contentView.addSubview($0)}
        [titleLabel, subtitleLabel].forEach { textStackView.addArrangedSubview($0)}
    }

    public func configure(with book: Book, showAddButton: Bool, isBookInCart: Bool, didTapCartButton: (() -> Bool)?) {
        self.book = book
        self.showAddButton = showAddButton
        self.isBookInCart = isBookInCart
        self.didTapCartButton = didTapCartButton
    }

    private func configUI() {
        guard let book else { return }
        coverView.image = UIImage(named: book.imageName)
        titleLabel.text = book.name
        subtitleLabel.text = book.edition
        addButton.isEnabled = book.available
    }
}

@available (iOS 17.0, *)
#Preview {
    BooksViewController(books: Book.books)
}
