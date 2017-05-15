//
//  GeoSearchResultsTableView.swift
//  Together
//
//  Created by Андрей Цай on 26.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

class GeoSearchResultsTableView: UITableView {
    
    fileprivate var searchResults: [String] = []
    fileprivate var _geoDelegate: GeoSearchDelegate!
    var geoDelegate: GeoSearchDelegate! {
        get{
            return _geoDelegate
        }
        set{
            _geoDelegate = newValue
            delegate = self
            dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.reloadData()
    }
}

extension GeoSearchResultsTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = self.searchResults[(indexPath as NSIndexPath).row]
        return cell
    }
}

extension GeoSearchResultsTableView:UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        let correctedAddress: String = self.searchResults[(indexPath as NSIndexPath).row].addingPercentEncoding(withAllowedCharacters: CharacterSet.symbols)!
        let stringURL = "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false"
        let url = URL(string: stringURL)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    guard  let resultsZero = dic["results"] as? NSArray, let results = resultsZero[0] as? NSDictionary, let geometry = results["geometry"] as? NSDictionary, let location = geometry["location"] as? NSDictionary, let lat  = location["lat"] as? Double, let lon = location["lng"] as? Double else { print("Error loading place data!"); return }
                    self._geoDelegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[(indexPath as NSIndexPath).row])
                }
                
            } catch {
                print("Error loading place data!")
            }
            
        })
        task.resume()
    }
    
    
}
