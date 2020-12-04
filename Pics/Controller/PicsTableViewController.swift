//
//  PicsTableViewController.swift
//  Pics
//
//  Created by 朱莎 on 4/12/20.
//  Copyright © 2020 Summer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class PicsTableViewController: UITableViewController {
    
    @IBOutlet weak var picsTableView: UITableView!
    var imageCache = [String:UIImage]()
    var pictures : [Result] = []
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        createActivityIndicator()
        activityIndicator.startAnimating()
        picsTableView.delegate = self
        picsTableView.dataSource = self
        super.viewDidLoad()
        let queue = DispatchQueue.global()
        queue.async {
            self.loadJsonData()
        }
    }
    //Create a activity indicator style.
    func createActivityIndicator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicator.superview!.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicator.superview!.centerYAnchor).isActive = true
        activityIndicator.restorationIdentifier = "indicator"
    }
    //Use Alamofire package to get JSON data from Picsum.photos.
    func loadJsonData()
    {
        Alamofire.request("https://picsum.photos/v2/list").responseJSON { response in
            //print("Response value \(response)")
            if let json = response.result.value{
                let pics = JSON(json)
                self.createPicture(pics: pics)
                self.picsTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    //Create picture array list.
    func createPicture(pics: JSON){
        for picture in pics.arrayValue {
            self.pictures.append(Result(
                author: picture["author"].stringValue,
                dowload_url: picture["download_url"].stringValue,
                height: picture["height"].stringValue,
                id: picture["id"].stringValue,
                url: picture["url"].stringValue,
                width: picture["width"].stringValue
            ))
        }
    }
    //Use Alamofire to download image.
    func loadPicture(pic:Result) -> UIImage{
        let dishName = pic.id
        var imageResult = UIImage()
        if let dishImage = imageCache[dishName]
        {
            imageResult = dishImage
        }else
        {
            Alamofire.request(pic.dowload_url)
                .responseImage { response in
                    debugPrint(response)
                    debugPrint(response.result)
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        self.imageCache[dishName] = image
                        imageResult = image
                    }
            }
            
        }
        return imageResult
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pictures.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picCell", for: indexPath) as! PicsTableViewCell
        cell.authorText.text = pictures[indexPath.row].author
        cell.pictureImage.image = loadPicture(pic: pictures[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailViewController{
            let indexPath = self.picsTableView.indexPathForSelectedRow
            controller.image = loadPicture(pic: pictures[indexPath!.row])
            controller.authorName = pictures[indexPath!.row].author
        }
        
    }
    
   
}
