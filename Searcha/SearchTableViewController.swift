//
//  SearchTableViewController.swift
//  Searcha
//
//  Created by 施馨檸 on 17/05/2018.
//  Copyright © 2018 施馨檸. All rights reserved.
//

import UIKit
import CoreLocation

struct Auth {
    static let clientID = "NEBAUMKVSI4QTBM0C25I5ZP1AZGPH1U12O4IYYDD25DJ5QBI"
    static let clientSecret = "A34J4AGQBFUX22XEGWA5OBNWU0M2GBS5PJXMSDSKZ43N5RT5"
}

class SearchTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var venues = [[String:Any]]()
    var currentLocation: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var isGet = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate, isGet == false  {
            isGet = true
            print("COORDINATE",coordinate)
            currentLocation = coordinate
            print("CURRENT COORDINATE", currentLocation)
            getNearbyInfo()
        }
    }
    
    func getNearbyInfo() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.string(from: date)
        
        let urlStr = "https://api.foursquare.com/v2/venues/explore?ll=\(currentLocation.latitude),\(currentLocation.longitude)&client_id=\(Auth.clientID)&client_secret=\(Auth.clientSecret)&v=\(dateStr)&limit=30&offset=20&section=food".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlRequest = URLRequest(url: URL(string: urlStr!)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, res, err) in
            
            if let returnData = data, let dic = (try? JSONSerialization.jsonObject(with:
            returnData)) as? [String:[String:Any]] {
                
                if let groups = dic["response"]?["groups"] as? [[String: Any]],
                    let itemsArray = groups[0]["items"] as? [[String:Any]],
                    itemsArray.count > 0 {
                    print("itemsArray ", itemsArray.count)
                    
                    for venue in itemsArray {
                        self.venues.append(venue)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

      
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? LocationTableViewCell
        print(venues.count)
        let venue = venues[indexPath.row]["venue"] as? [String:Any]
        if let name = venue?["name"] as? String, let id = venue?["id"] as? String {
            cell?.venueNameLabel.text = "\(name)"
        }
        
        return cell!
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DetailViewController
        
        let row = tableView.indexPathForSelectedRow?.row
        let venue = venues[row!]["venue"] as? [String:Any]
        controller?.name = venue?["name"] as? String
        
        let location = venue?["location"] as? [String:Any]
        controller?.address = location?["address"] as? String
        controller?.latitude = location?["lat"] as? CLLocationDegrees
        controller?.longitude = location?["lng"] as? CLLocationDegrees
        controller?.distance = location?["distance"] as? Int

        
        let category = venue?["categories"] as? [[String:Any]]
        let pluralName = category?[0]["pluralName"] as? String
        controller?.category = pluralName
    }
}
