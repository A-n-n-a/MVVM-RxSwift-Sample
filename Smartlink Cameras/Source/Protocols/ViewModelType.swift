//
//  ViewModelType.swift
//  Smartlink
//
//  Created by Minhaz Mohammad on 11/28/18.
//  Copyright © 2018 SecureNet Technologies, LLC. All rights reserved.
//

import UIKit

enum Attachable<VM: ViewModelProtocol> {
    
    case detached(VM.Dependency)
    case attached(VM.Dependency, VM)
    
    mutating func bind(_ bindings: VM.Bindings) -> VM {
        switch self {
            case let .detached(dependency), let .attached(dependency, _):
                let vm = VM(dependency: dependency, bindings: bindings)
                self = .attached(dependency, vm)
                return vm
        }
    }
    
}

protocol ViewModelProtocol {
    associatedtype Dependency
    associatedtype Bindings
    
    init(dependency: Dependency, bindings: Bindings)
}

protocol ViewModelAttachingProtocol: AnyObject {
    associatedtype ViewModel: ViewModelProtocol
    
    var bindings: ViewModel.Bindings { get }
    var viewModel: Attachable<ViewModel>! { get set }
    
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel
    func configureReactiveBinding(viewModel: ViewModel) -> ViewModel
}

extension ViewModelAttachingProtocol where Self: UIViewController {
    
    @discardableResult
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel {
        viewModel = wrapper
        loadViewIfNeeded()
        let vm = viewModel.bind(bindings)
        return configureReactiveBinding(viewModel: vm)
    }
    
}
