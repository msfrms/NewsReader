//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import SUtils

class BaseViewController: ASViewController<ASDisplayNode> {

    struct Props {
        let didLoad: Command
        let willAppear: Command
        let didAppear: Command
        let willDisappear: Command
        let didDisappear: Command

        init(didLoad: Command,
             willAppear: Command,
             didAppear: Command,
             willDisappear: Command,
             didDisappear: Command) {
            self.didLoad = didLoad
            self.willAppear = willAppear
            self.didAppear = didAppear
            self.willDisappear = willDisappear
            self.didDisappear = didDisappear
        }

        init() { self.init(didLoad: .nop, willAppear: .nop, didAppear: .nop, willDisappear: .nop, didDisappear: .nop) }
    }

    var props: Props = Props()

    convenience init(node: ASDisplayNode, props: Props) {
        self.init(node: node)
        self.props = props
    }

    override init(node: ASDisplayNode) {
        super.init(node: node)
        self.props = Props()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.props = Props()
        super.init(coder: aDecoder)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.props.didLoad.execute()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.props.willAppear.execute()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.props.didAppear.execute()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.props.willDisappear.execute()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.props.didDisappear.execute()
    }
}
