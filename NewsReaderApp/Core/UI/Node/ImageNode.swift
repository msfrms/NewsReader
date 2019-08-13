//
// Created by Radaev Mikhail on 2019-08-11.
// Copyright (c) 2019 msfrms. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import ADKUtils

public class ImageNode: ASDisplayNode, Renderer {

    public struct Styles {
        let backgroundColor: UIColor
    }

    public enum ViewModel {
        case data(Data)
        case url(URL)
    }

    private let imageNode = ASNetworkImageNode()
    private let styles: Styles

    public init(styles: Styles) {
        self.styles = styles
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    public override func didLoad() {
        super.didLoad()
        imageNode.backgroundColor = styles.backgroundColor
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return imageNode.insets(.zero)
    }

    public func render(viewModel: ViewModel) {
        switch viewModel {
        case .data(let data):
            imageNode.setURL(nil, resetToDefault: true)
            imageNode.defaultImage = UIImage(data: data)
        case .url(let url):
            imageNode.url = url
        }        
    }
}
