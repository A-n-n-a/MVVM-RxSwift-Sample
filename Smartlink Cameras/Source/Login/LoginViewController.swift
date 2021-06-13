//
//  LoginViewController.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class LoginViewController: UIViewController, ViewModelAttachingProtocol {

    // MARK: - Conformance to ViewModelAttachingProtocol
    var bindings: LoginViewModel.Bindings {
        return LoginViewModel.Bindings(loginButtonTap: loginButton.rx.tap.asObservable())
    }
    
    var viewModel: Attachable<LoginViewModel>!
    
    func configureReactiveBinding(viewModel: LoginViewModel) -> LoginViewModel {
        return viewModel
    }
    
    
    // MARK: - Logic variables
    fileprivate let disposeBag = DisposeBag()
    
    
    // MARK: - UI variables
    fileprivate var areConstraintsSet: Bool = false
    
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign In".localized(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2772967219, green: 0.4145590663, blue: 0.4646431804, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        contentView.addGestureRecognizer(tapGesture)
        
        return contentView
    }()
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "bg_effect")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "logo_light")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate lazy var usernameTextField: TitledTextField = {
        let textField = TitledTextField(placeholder: "Username".localized())
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        
        textField.rx.text.orEmpty
            .debounce(RxSwift.RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { username in
            if !username.isEmpty {
                self.getBaseUrl(username: username)
            }
        }, onDisposed: nil)
        .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEndOnExit).subscribe { (onNext) in
            self.focusOnPasswordTextField()
        }.disposed(by: disposeBag)
        
        return textField
    }()
    
    fileprivate lazy var passwordTextField: TitledTextField = {
        let textField = TitledTextField(placeholder: "Password".localized())
        textField.isSecureTextEntry = true
        
        textField.rx.controlEvent(.editingDidEndOnExit).subscribe { (onNext) in
            self.endEditing()
        }.disposed(by: disposeBag)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var checkmarkView: UIView = {
        let checkmarkView = UIView()
        checkmarkView.layer.borderColor = #colorLiteral(red: 0.5528972149, green: 0.5529660583, blue: 0.5528737307, alpha: 1).cgColor
        checkmarkView.layer.borderWidth = 1
        checkmarkView.backgroundColor = .white
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkView
    }()
    
    fileprivate lazy var stackView: UIView = {
        let label = UILabel()
        label.text = "Remember Me".localized()
        label.textColor = #colorLiteral(red: 0.5528972149, green: 0.5529660583, blue: 0.5528737307, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [checkmarkView, label])
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        checkmarkView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkmarkView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rememberMe))
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    fileprivate lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?".localized()
        label.textColor = #colorLiteral(red: 0.5528972149, green: 0.5529660583, blue: 0.5528737307, alpha: 1)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPassword))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    fileprivate lazy var getStartedLabel: UILabel = {
        let attrString = NSMutableAttributedString(string: "Installing a DIY System? ".localized(),
                                                   attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])

        attrString.append(NSMutableAttributedString(string: "Get Started".localized(),
                                                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
        let label = UILabel()
        label.attributedText = attrString
        label.textColor = #colorLiteral(red: 0.5528972149, green: 0.5529660583, blue: 0.5528737307, alpha: 1)
        label.textAlignment = .center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getStarted))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !areConstraintsSet {
            areConstraintsSet = true
            configureConstraints()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        handleKeyboardAppearance()
    }
    
    // MARK: textFields handling
    @objc fileprivate func endEditing() {
        view.endEditing(true)
    }
    
    @objc fileprivate func focusOnPasswordTextField() {
        passwordTextField.becomeFirstResponder()
    }
    
    fileprivate func handleKeyboardAppearance() {
        let observableHeight = Observable
                .from([
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                                .map { notification -> CGFloat in
                                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                                },
                        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                                .map { _ -> CGFloat in
                                    0
                                }
                ])
                .merge()
        
        observableHeight.subscribe { (onNext) in
            if let height = onNext.element {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
        }.disposed(by: disposeBag)
    }
    
    fileprivate func getBaseUrl(username: String) {
        let vm = self.attach(wrapper: viewModel)
        vm.getBaseUrl(username: username)
//        let url = "http://registration.securenettech.com/registration.php"
//        let usernameParams = UsernameParameters(username: username)
//        let requestData = RestApiData(url: url, httpMethod: .post, parameters: usernameParams)
//        APIService().call(requestData: requestData) { (response: Result<EnvironmentResponse>) in
//            DispatchQueue.main.async {
//                print("Base Url:")
//                switch response {
//                case .success(let result):
//                    print(result.platform.baseURL)
//                case .failure(let error):
//                    print(error.error)
//                }
//            }
//        }
    }
    
    // MARK: Handling Gestures 
    @objc fileprivate func rememberMe() {
        checkmarkView.backgroundColor = checkmarkView.backgroundColor == .white ? .green : .white
    }
    
    @objc fileprivate func forgotPassword() {
        
    }
    
    @objc fileprivate func getStarted() {
        
    }

    deinit {
        
    }

}

extension LoginViewController {
    
    fileprivate func configureAppearance() {
        view.backgroundColor = .orange
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(stackView)
        contentView.addSubview(forgotPasswordLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(getStartedLabel)
    }
    
    fileprivate func configureConstraints() {
        
        configureScrollViewConstraints()
        configureContentViewConstraints()
        configureBackgroundImageViewConstraints()
        configureLogoImageViewConstraints()
        configureUsernameTextFieldConstraints()
        configurePasswordTextFieldConstraints()
        configureStackViewConstraints()
        configureForgotPasswordLabelConstraints()
        configureSigninButtonConstraints()
        configureGetStartedLabelConstraints()
    }
    
    func configureScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureContentViewConstraints() {
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            heightConstraint
            
        ])
    }
    
    func configureBackgroundImageViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        ])
    }
    
    func configureLogoImageViewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: 30),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureUsernameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: 20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func configurePasswordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func configureStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30)
        ])
    }
    
    func configureForgotPasswordLabelConstraints() {
        NSLayoutConstraint.activate([
            forgotPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: forgotPasswordLabel.trailingAnchor, constant: 30),
            forgotPasswordLabel.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10)
        ])
    }
    
    func configureSigninButtonConstraints() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(greaterThanOrEqualTo: passwordTextField.bottomAnchor, constant: 60),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func configureGetStartedLabelConstraints() {
        NSLayoutConstraint.activate([
            getStartedLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: getStartedLabel.bottomAnchor, constant: 30),
            getStartedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: getStartedLabel.trailingAnchor, constant: 20),
            getStartedLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffset = scrollView.contentSize.height - UIScreen.main.bounds.height
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
        
        if scrollView.contentOffset.y > maxOffset {
            scrollView.contentOffset.y = maxOffset
        }
    }
}
