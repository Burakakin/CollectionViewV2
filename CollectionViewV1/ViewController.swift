//
//  ViewController.swift
//  CollectionViewV1
//
//  Created by Burak Akin on 17.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit


struct AppleApi: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let results: [Result]
}
struct Result: Decodable {
    let name: String
    let artWorkUrl: String
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case artWorkUrl = "artworkUrl100"
    }
}

extension UIImageView {
    func downloadImages(arrayImage: String) {
        let url = URL(string: arrayImage)
        URLSession.shared.dataTask(with: url!) { (imgData, response, err) in
            guard let imgData = imgData else { return }
            DispatchQueue.main.async{
              self.image = UIImage(data: imgData)
            }
            }.resume()
    }
    
}


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var feedResult = [Result]()
   
   
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getArtistData(UrlString: "https://rss.itunes.apple.com/api/v1/de/ios-apps/new-apps-we-love/all/25/explicit.json")
        //print(feedResult)
        valueTextField.becomeFirstResponder()
    }
    
    @IBAction func ValueChanged(_ sender: UIButton) {
        feedResult.removeAll()
        print(valueTextField.text!)
        getArtistData(UrlString: "https://rss.itunes.apple.com/api/v1/\(valueTextField.text!)/ios-apps/new-apps-we-love/all/25/explicit.json")
    }
    
    
    func getArtistData(UrlString: String) {
        let url = URL(string: UrlString)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }
               self.setProperties(jsonData: data)
               
            }.resume()
    }
    
   
    
    func setProperties(jsonData: Data) {
        do{
            let appData = try JSONDecoder().decode(AppleApi.self, from: jsonData)
            let dataApp = appData.feed.results
            //print(dataApp)
            DispatchQueue.main.async {
                self.feedResult.append(contentsOf: dataApp)
                self.myCollectionView.reloadData()
                print(self.feedResult[0].name)
            }
        
        }catch let err{
            print("Error",err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let info = feedResult[indexPath.row]
        cell.appLabel.text = info.name
        
        //Learn how to display the imageUrl inside array in UIimageView
        cell.customCollectionImage.downloadImages(arrayImage: info.artWorkUrl)
        
        cell.customCollectionImage.layer.cornerRadius = (cell.customCollectionImage.frame.height)/2
        cell.customCollectionImage.clipsToBounds = true
        cell.customCollectionImage.layer.borderWidth = 5
        cell.customCollectionImage.layer.borderColor = UIColor.brown.cgColor
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let rowSelected = (sender as! IndexPath).row
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "showDetail"{
            if let destinationVC = segue.destination as? DetailViewController{
                destinationVC.text = String(feedResult[rowSelected].name)
            }
        }
    }

}

