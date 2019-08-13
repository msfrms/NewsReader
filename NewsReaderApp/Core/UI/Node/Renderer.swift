//
// Created by Radaev Mikhail on 2019-08-11.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation

public protocol Renderer {
    associatedtype ViewModel
    func render(viewModel: ViewModel)
}