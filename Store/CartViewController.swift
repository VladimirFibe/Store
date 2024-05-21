import UIKit

final class CartViewController: UIViewController {
    private var booksController: BooksViewController?
    private lazy var panelView: CartPanelView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        return $0
    }(CartPanelView())

    private var books: [Book]
    init(books: [Book]) {
        self.books = books
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        isModalInPresentation = true
        setupNavigationBar()
        setupPanelView()
        setupBooksController()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Cart"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })

    }

    private func setupPanelView() {
        view.addSubview(panelView)
        NSLayoutConstraint.activate([
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panelView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    private func setupBooksController() {
        booksController = BooksViewController(books: books, config: .init(showAddButton: false))
        if let booksController {
            booksController.willMove(toParent: self)
            addChild(booksController)
            view.addSubview(booksController.view)
            booksController.didMove(toParent: self)
            booksController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                booksController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                booksController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                booksController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                booksController.view.bottomAnchor.constraint(equalTo: panelView.topAnchor)
            ])
        }
    }
}

@available (iOS 17.0, *)
#Preview {
    CartViewController(books: Book.books)
}
