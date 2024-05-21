import UIKit

final class CartPanelView: UIView {
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private lazy var informationStackView: UIStackView = {
        $0.alignment = .center
        $0.distribution = .equalCentering
        return $0
    }(UIStackView())

    private lazy var costLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.text = "Cost: $9.41"
        return $0
    }(UILabel())

    private lazy var shippingSpeedButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = "Shipping Speed"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        $0.configuration = config
        $0.showsMenuAsPrimaryAction = true
        $0.changesSelectionAsPrimaryAction = true
        $0.menu = UIMenu(children: [
            UIAction(title: "Express Shipping", image: UIImage(systemName: "hare.fill")) { _ in
                print("Express Shipping")
            },
            UIAction(title: "Standard Shipping", image: UIImage(systemName: "tortoise.fill")) { _ in
                print("Standard Shipping")
            }
        ])
        return $0
    }(UIButton(type: .system))

    private lazy var checkoutButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.imagePadding = 5
        config.buttonSize = .large
        config.cornerStyle = .medium
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        $0.configuration = config
        $0.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.checkingOut
            config?.title = self.checkingOut ? "Checking Out ..." : "Checkout"
            button.configuration = config
        }
        $0.addAction(UIAction { _ in
            self.checkingOut = true
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.checkingOut = false
            }
        }, for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private var checkingOut = false {
        didSet {
            self.checkoutButton.setNeedsUpdateConfiguration()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        addSubview(stackView)
        stackView.addArrangedSubview(informationStackView)
        informationStackView.addArrangedSubview(costLabel)
        informationStackView.addArrangedSubview(shippingSpeedButton)
        stackView.addArrangedSubview(checkoutButton)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available (iOS 17.0, *)
#Preview {
    CartViewController(books: Book.books)
}
