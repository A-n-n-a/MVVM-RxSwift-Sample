//
//  LoginViewController.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import RxSwift
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
        button.setTitle(NSLocalizedString("Login", comment: "Login button text"), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    fileprivate lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
        let textField = TitledTextField(placeholder: NSLocalizedString("Username", comment: ""))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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

        // Do any additional setup after loading the view.
        configureAppearance()
    }
    

    deinit {
        
    }

}

extension LoginViewController {
    
    fileprivate func configureAppearance() {
        view.backgroundColor = .orange
        
//        view.addSubview(loginButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(usernameTextField)
    }
    
    fileprivate func configureConstraints() {
        NSLayoutConstraint.activate([
//            loginButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
//            loginButton.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            
            logoImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: 30),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 40),
            contentView.bottomAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: 20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}
