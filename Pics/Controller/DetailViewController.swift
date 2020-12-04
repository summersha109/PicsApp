//
//  DetailViewController.swift
//  Pics
//
//  Created by 朱莎 on 4/12/20.
//  Copyright © 2020 Summer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailPic: UIImageView!
    
    @IBOutlet weak var detailAuthor: UILabel!
    
    var image: UIImage?
    var authorName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = image,
            let authorName = authorName{
            detailPic.image = image
            detailAuthor.text = authorName
        }
        
    }
    

   

    
}
