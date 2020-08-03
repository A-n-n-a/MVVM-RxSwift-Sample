//
//  LoginViewModel.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import Foundation
import RxSwift

final class LoginViewModel: ViewModelProtocol {
    
    typealias Dependency = HasUserService
    
    struct Bindings {
        let loginButtonTap: Observable<Void>
    }
    
    let loginResult: Observable<Void>
    
    init(dependency: Dependency, bindings: Bindings) {
        loginResult = bindings.loginButtonTap
            .do(onNext: { _ in dependency.userService.login()  })
    }
    
    func getBaseUrl(username: String) {
        let url = "http://registration.securenettech.com/registration.php"
        let usernameParams = UsernameParameters(username: username)
        let requestData = RestApiData(url: url, httpMethod: .post, parameters: usernameParams)
        APIService().call(requestData: requestData) { (response: Result<EnvironmentResponse>) in
            DispatchQueue.main.async {
                print("Base Url:")
                switch response {
                case .success(let result):
                    print(result.platform.baseURL)
                case .failure(let error):
                    print(error.error)
                }
            }
        }
    }
    
    deinit {
        
    }
    
}
