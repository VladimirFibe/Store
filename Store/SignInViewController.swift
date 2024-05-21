import UIKit

final class SignInViewController: UIViewController {
    private var signingIn = false {
        didSet { signInButton.setNeedsUpdateConfiguration() }
    }
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private lazy var signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .headline)
            return outgoing
        }
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.right")
        config.imagePadding = 5
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        $0.configuration = config
        $0.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.showsActivityIndicator = self.signingIn
            config?.imagePlacement = self.signingIn ? .leading : .trailing
            config?.title = self.signingIn ? "Signing ..." : "Sign in"
            button.isEnabled = !self.signingIn
            button.configuration = config
        }
        $0.addAction(UIAction { _ in
            self.signingIn = true
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.signingIn = false
            }
        }, for: .primaryActionTriggered)
        return $0
    }(UIButton(type: .system))

    private lazy var helpButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .large
        config.title = "Get Help"
        $0.configuration = config
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(children: [
            UIAction(title: "Forgot Password", image: UIImage(systemName: "key.fill")) { _ in
                print("Forgot Password")
            },
            UIAction(title: "Contact Support", image: UIImage(systemName: "person.crop.circle.badge.questionmark")) { _ in
                print("Contact Support")
            }
        ])
        return $0
    }(UIButton(type: .system))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })
        setupStackView()
    }

    private func setupStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(helpButton)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

@available (iOS 17.0, *)
#Preview {
    SignInViewController()
}
