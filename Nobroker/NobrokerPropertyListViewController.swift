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
/*
 &type=BHK3/BHK4/BHK2
 &buildingType=AP/IH/IF
 &furnishing=FULLY_FURNISHED/SEMI_FURNISHED
 */
class NobrokerPropertyListViewController: UITableViewController {
    var rootImageUrl = "http://d3snwcirvb4r88.cloudfront.net/images/"
    var model = [PropertyModel]()
    var loadingMoreView:InfiniteScrollActivityView?
    var didScrollOffset = 0
    var total_Count = 0
    var offset = 1
    var photoUrl = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure_Loading()
        startActivity()
        getProperties()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    // MARK: API Call
    func getProperties(){
        let api = "http://www.nobroker.in/api/v1/property/filter/region/ChIJLfyY2E4UrjsRVq4AjI7zgRY/?lat_lng=12.9279232,77.6271078&rent=0,500000&travelTime=30&pageNo=\(self.offset)"
        print("Api:\(api)")
        Alamofire.request(api, method:.get, parameters: nil)
            .responseJSON { response in
                //print(response.result)   // result of response serialization
                guard response.result.error == nil else {
                    print(response.result.error!)
                    return
                }
                if let json = response.data {
                    let json_Data = JSON(data:json)
                    print("json:\(json_Data)")
                    
                    if json_Data["statusCode"] == 200{
                        self.total_Count = json_Data["otherParams"]["total_count"].int!
                        let data = json_Data["data"].array!
                        for i in data{
                            for k in i["photos"]{
                                let url = k.1["imagesMap","original"].string!
//                                print("url:\(url)")
                                self.photoUrl.append(url)
                            }
//                            for (index,subJson):(String, JSON) in i {
//                            print("index,subjson:\(index,subJson):")
//                            }
//                            
                            let m = PropertyModel(json:i)
                            self.model.append(m)
                            }
                            
                    }else{
                        print("Error Status code 500")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.offset = self.offset+1
                    self.stopActivity()
                }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
