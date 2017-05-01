//
//  NobrokerPropertyListViewController.swift
//  Nobroker
//
//  Created by Sanjay Mali on 29/04/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
class NobrokerPropertyListViewController: UITableViewController {
    var rootImageUrl = "http://d3snwcirvb4r88.cloudfront.net/images/"
    var model = [PropertyModel]()
    var loadingMoreView:InfiniteScrollActivityView?
    var didScrollOffset = 0
    var total_Count = 0
    var offset = 1
    var photoUrl = [String]()
    var type = ""
    var buildingType = ""
    var furnishing = ""

    @IBOutlet weak var segmentCotrol: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure_Loading()
        DispatchQueue.main.async {
        self.getProperties()
        }
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    // MARK: API Call
    func getProperties(){
        startActivity()
        let api = "http://www.nobroker.in/api/v1/property/filter/region/ChIJLfyY2E4UrjsRVq4AjI7zgRY/?lat_lng=12.9279232,77.6271078&rent=0,500000&travelTime=30&pageNo=\(self.offset)&type=\(self.type)&buildingType=\(self.buildingType)&furnishing=\(furnishing)"
        print("api:\(api)")
        Alamofire.request(api, method:.get, parameters: nil)
            .responseJSON { response in
                //print(response.result)   // result of response serialization
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                if let json = response.data {
                    let json_Data = JSON(data:json)
                    
                    if json_Data["statusCode"] == 200{
                        self.total_Count = json_Data["otherParams"]["total_count"].int!
                        let data = json_Data["data"].array!
                        for i in data{
                            for k in i["photos"]{
                                let url = k.1["imagesMap","original"].string!
                                self.photoUrl.append(url)
                            }
                            let m = PropertyModel(json:i)
                            self.model.append(m)
                            }
                            
                    }else{
                        print("Error Status code 500")
                    }
                }
                    self.reloadTable()
                    self.loadingMoreView?.stopAnimating()
                    self.offset = self.offset+1
                    self.stopActivity()
            
        }
        reloadTable()
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @IBAction func filterProperty(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            self.type = "BHK3/BHK4/BHK2"
            self.buildingType = ""
            self.furnishing = ""
            removeExistingData()
            getProperties()
            break
        case 1:
            self.buildingType = "AP/IH/IF"
            self.type = ""
            self.furnishing = ""
            removeExistingData()
            getProperties()
            break
        case 2:
            self.furnishing = "FULLY_FURNISHED/SEMI_FURNISHED"
            self.buildingType = ""
            self.furnishing = ""
            removeExistingData()
            getProperties()
            break
        default:
            print("default")
        }
    }
    func removeExistingData(){
        self.offset  = 1
        self.model.removeAll()
        self.photoUrl.removeAll()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PropertyListCell
        cell.cellView.layer.cornerRadius = 3.0
        cell.cellView.layer.masksToBounds = true
        let data = model[indexPath.row]
        cell.propertyTitle.text = data.propertyTitle
        cell.propertySecondTitle.text = data.secondaryTitle
        let rupee = "\u{20B9}"
        cell.propertyRent.text = rupee + "\(formater(num:data.rent!))"
        cell.propertyFurnishing.text = data.furnishing
        cell.propertyBuitupArea.text = "\(data.propertySize!) Sq.ft Built up area"
        
        let url = photoUrl[indexPath.row]
        let keyUrl = url.characters.split{$0 == "_"}.map(String.init)
        print("URL:\(keyUrl[0])")
        let originalUrl = rootImageUrl + keyUrl[0] + "/" + url
        print("Ori:\(originalUrl)")
        URLSession.shared.dataTask(with: NSURL(string: originalUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                cell.propertyImage.image = image
            })
            
        }).resume()
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
extension NobrokerPropertyListViewController {
    
    
    
    
    func startActivity(){
        KRProgressHUD.show()
        KRProgressHUD.set(activityIndicatorStyle: .color(UIColor.black,.black))
    }
    
    func stopActivity(){
        let delay = DispatchTime.now() + 0
        DispatchQueue.main.asyncAfter(deadline: delay) {
            KRProgressHUD.dismiss()
        }
    }
    func formater(num:Int)->String{
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        let repuee = f.string(from:NSNumber(value:num))
        return repuee!
    }
    /**
     * @discussion Lazy loading implementation method
     */
    func configure_Loading(){
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    /**
     * @discussion When did user reached last row of table view.
     * Make api call with offset and limit get next slot of data
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the position of one screen length before the bottom of the results
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        //When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                        print("totalPropertyCount=\(total_Count):offset=\(offset):didScrollOffset=\(didScrollOffset)")
            if total_Count > model.count && offset > didScrollOffset {
                didScrollOffset = offset
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                getProperties()
            }
        }
        return
    }
    
    
    
}
//extension UIImageView {
//    public func imageFromServerURL(urlString: String) {
//        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                print(error!)
//                return
//            }
//            DispatchQueue.main.async(execute: { () -> Void in
//                let image = UIImage(data: data!)
//                self.image = image
//            })
//            
//}).resume()
//}
//}
