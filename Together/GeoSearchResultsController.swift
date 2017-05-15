//
//  SearchResultsController.swift
//  PlacesLookup
//
//  Created by Malek T. on 9/30/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

protocol GeoSearchLocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class GeoSearchResultsController: UITableViewController {

    var searchResults: [String]!
    var delegate: GeoSearchLocateOnTheMap!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = self.searchResults[(indexPath as NSIndexPath).row]
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        self.dismiss(animated: true, completion: nil)
        let correctedAddress: String = self.searchResults[(indexPath as NSIndexPath).row].addingPercentEncoding(withAllowedCharacters: CharacterSet.symbols)!
        let stringURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false"
        let url = URL(string: stringURL)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    guard  let resultsZero = dic["results"] as? NSArray, let results = resultsZero[0] as? NSDictionary, let geometry = results["geometry"] as? NSDictionary, let location = geometry["location"] as? NSDictionary, let lat  = location["lat"] as? Double, let lon = location["lng"] as? Double else { print("Error loading place data!"); return }
                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[(indexPath as NSIndexPath).row])
                }
                
            } catch {
                print("Error loading place data!")
            }
            
        }) 
        task.resume()
    }

    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }

}
