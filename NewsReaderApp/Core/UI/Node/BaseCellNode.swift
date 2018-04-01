//
// Created by Radaev Mikhail on 31.03.2018.
// Copyright (c) 2018 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class BaseCellNode: ASCellNode {
    override init() {
        super.init()
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.automaticallyManagesSubnodes = true
    }
}