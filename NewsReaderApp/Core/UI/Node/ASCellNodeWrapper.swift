//
// Created by Radaev Mikhail on 2019-08-11.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import ADKUtils

extension ASLayoutElement {
    public var spec: ASLayoutSpec {
        return ASWrapperLayoutSpec(layoutElement: self)
    }
}

public class ASCellNodeWrapper: ASCellNode {

    private let node: ASLayoutElement

    public init(with node: ASLayoutElement) {
        self.node = node
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return self.node.spec
    }
}