//
//  DetailViewController.swift
//  CollectionViewV1
//
//  Created by Burak Akin on 19.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
 
    @IBOutlet weak var detailVCLabel: UILabel!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      detailVCLabel.text = text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
