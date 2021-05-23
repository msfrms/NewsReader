//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SUtils

public protocol LifeCycle {
    func didLoad()
}

public class BaseViewController: ASDKViewController<ASDisplayNode> {

    private let presenter: LifeCycle

    public init(node: ASDisplayNode, presenter: LifeCycle) {
        self.presenter = presenter
        super.init(node: node)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
    }
}
