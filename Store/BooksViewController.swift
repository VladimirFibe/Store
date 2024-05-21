import UIKit

class BooksViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Book>
    private lazy var dataSource = makeDataSouce()
    private var booksInCart: Set<UUID> = []
    enum Section {
        case main
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var books: [Book]
    private var config = Configuration.default
    struct Configuration {
        let showAddButton: Bool
        static let `default` = Configuration(showAddButton: true)
    }

    init(books: [Book], config: Configuration = .default) {
        self.books = books
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Books"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        let cartAction = UIAction { _ in
            let controller = UINavigationController(rootViewController: CartViewController(books: self.books.filter { self.isInCart($0)}))
            self.present(controller, animated: true)
        }
        let accountAction = UIAction { _ in
            let controller = UINavigationController(rootViewController: SignInViewController())
            self.present(controller, animated: true)
        }
        let cartButton = UIBarButtonItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            primaryAction: cartAction,
            menu: nil
        )
        let accountButton = UIBarButtonItem(
            title: "Sign-in",
            image: UIImage(systemName: "person.crop.circle"),
            primaryAction: accountAction,
            menu: nil
        )
        navigationItem.rightBarButtonItems = [accountButton, cartButton]
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = makeLayout()
        applySnapshot(animatingDifferences: false)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func isInCart(_ book: Book) -> Bool {
        booksInCart.contains(book.id)
    }

    func toggleCartStatus(for book: Book) -> Bool {
        if booksInCart.contains(book.id) {
            booksInCart.remove(book.id)
        } else {
            booksInCart.insert(book.id)
        }
        print(booksInCart)
        return isInCart(book)
    }
}
// MARK: - DataSource Implementation
extension BooksViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(books)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeDataSouce() -> DataSource {
        collectionView.register(BookCollectionCell.self, forCellWithReuseIdentifier: BookCollectionCell.reuseIdentifier)
        return DataSource(collectionView: collectionView) { collectionView, indexPath, book in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCell.reuseIdentifier, 
                                                                for: indexPath) as? BookCollectionCell else { fatalError()}
            cell.configure(
                with: book,
                showAddButton: self.config.showAddButton,
                isBookInCart: self.isInCart(book),
                didTapCartButton: { self.toggleCartStatus(for: book)}
            )
            return cell
        }
    }
}
// MARK: - Layout Implementation
extension BooksViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}

@available (iOS 17.0, *)
#Preview {
    BooksViewController(books: Book.books)
}
