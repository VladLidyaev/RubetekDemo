//
//  DetailsViewController.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class DetailsViewController: RubetekViewController {

    @IBOutlet weak var mainImageView  : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    public func setImage(image : UIImage) {
        guard self.mainImageView != nil else { return }
        self.mainImageView.image = image
    }
    
    public func setTitle(title : String) {
        guard self.titleLabel != nil else { return }
        self.titleLabel.text = title
    }
    
    @IBAction func buttonAction(_ sender : UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
