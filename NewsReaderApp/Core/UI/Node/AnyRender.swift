//
// Created by Radaev Mikhail on 2019-08-12.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation

public class AnyRender<ViewModel>: Renderer {

    private let view: (ViewModel) -> Void

    public init<R: Renderer>(render: R) where R.ViewModel == ViewModel {
        self.view = render.render
    }

    public func render(viewModel: ViewModel) {
        view(viewModel)
    }
}