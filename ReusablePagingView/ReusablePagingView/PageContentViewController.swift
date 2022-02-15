//
//  PageContentViewController.swift
//  ReusablePagingView
//
//  Created by sun on 2022/02/15.
//

import UIKit

// resuable view
class PageContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var index: Int!
    var imageString: String!
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.backgroundColor = color
    }
}
