import UIKit

class ViewController: UIViewController {
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
    private var books = Book.books
    private var config = Configuration.default
    struct Configuration {
        let showAddButton: Bool

        static let `default` = Configuration(showAddButton: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
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
extension ViewController {
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
extension ViewController {
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
    ViewController()
}
