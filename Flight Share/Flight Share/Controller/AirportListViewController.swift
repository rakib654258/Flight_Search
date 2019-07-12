//
//  AirportListViewController.swift
//  Flight Share
//
//  Created by macOS Mojave on 12/7/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit

struct Root: Codable {
    let  data: [InnerItem]
}
struct InnerItem:Codable {
    let Code: String?
    let Value: String?
    let City: String?
    let Country: String?
    let Latitude: String?
    let Longitude: String?
    
    private enum CodingKeys : String, CodingKey {
        case Code = "Code", Value = "Value", City = "City", Country = "Country", Latitude = "Latitude", Longitude = "Longitude"
    }
}

//var airportInfo: [AirportList] = []
var airportName: [String] = []

class AirportListViewController: UIViewController,UITableViewDataSource,UITabBarDelegate,UISearchBarDelegate {
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var Airport = ["Shahajalal Airport","Kamal Airport","jamal Airport"]
    var city = ["Dhaka","Chitagon","khulna"]
    
    var searching = false
    var filterArray: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flying From"
        readJson()
        // Do any additional setup after loading the view.
    }
    
    // read json file for Airport List
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "AirportList", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                
//                do{
//                    let airportListData = try JSONDecoder().decode([AirportList].self, from: data)
//                    airportInfo = airportListData
//                    for i in 0..<airportListData.count{
//                        airportName.append(airportListData[i].Value!)
//                    }
//                }
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print("JSON Dictionary value: ",object["AirportList"])
//                    do {
//                        let decoder = JSONDecoder()
//                        let gitData = try decoder.decode([Root].self, from: data)
//                        for singleData in 0..<gitData.count{
//                            print(singleData)
//                        }
//                    } catch let err {
//                        print("\nErr", err.localizedDescription)
//                    }
                    
                } else if let object = json as? [Any] {
                    // json is an array
                    print("JSON Array value: ",object)
                    
                    
                    
//                    self.filterArray = airportName
//                    DispatchQueue.main.async {
//                        self.tableViewOutlet.reloadData()
//                    }
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print("Error message: ",error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            let count = filterArray?.count
            return count!
        }else{
            return Airport.count
        }
        //return airportName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! customTableViewCell
//        if let value = self.filterArray?[indexPath.row]{
//            cell.airportLabel.text = value
//        }
        //cell.airportLabel.text = airportName[indexPath.row]
        
        cell.airportLabel.text = "\(city[indexPath.row]),\(Airport[indexPath.row])"
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        if ((searchBar.text?.isEmpty)!){
            filterArray = city 
        }else{
            self.filterArray = city.filter({ $0.lowercased().contains(searchBar.text!.lowercased())})
        }
        self.tableViewOutlet.reloadData()
    }

}
