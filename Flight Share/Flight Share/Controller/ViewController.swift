//
//  ViewController.swift
//  Flight Share
//
//  Created by macOS Mojave on 4/7/19.
//  Copyright © 2019 macOS Mojave. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

class ViewController: UIViewController {

    @IBOutlet weak var depatureOutlet: UILabel!
    @IBOutlet weak var returnLblOutlet: UILabel!
    @IBOutlet weak var seatTypeLbl: UILabel!
    @IBOutlet weak var travellerLbl: UILabel!
    
    var depatureORreturn = 0
    var DepatureDate = ""
    var ReturnDate = ""
    
    var searchKey = ""
    var seatType: String = "Seat Type" ; var child: Int = 0 ; var adult: Int = 0 ; var infant: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backIteam = UIBarButtonItem()
        backIteam.title = "X"
        navigationItem.backBarButtonItem = backIteam
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Seat Value in label
        let userDeafault = UserDefaults()
        //set date in date label
//        if let data = userDeafault.object(forKey: "Date"){
//            if let dataString = data as? String{
//                if depatureORreturn == 1{
////                    ReturnDate = dateFormatter.string(from: dataString)
////                    let returnDateSplit = ReturnDate.characters.split{$0 == ","}.map(String.init)
//                    self.depatureOutlet.text = dataString
//                }
//                else if depatureORreturn == 2{
//                    self.returnLblOutlet.text = dataString
//                }
//            }
//        }
        
        if let data = userDeafault.object(forKey: "SeatType"){
            if let dataString = data as? String{
                self.seatTypeLbl.text = dataString
                seatType = dataString
            }
        }
        if let data = userDeafault.object(forKey: "Traveller"){
            if let dataString = data as? String{
                self.travellerLbl.text = dataString
            }
        }
        if let data = userDeafault.object(forKey: "adult"){
            adult = data as! Int
        }
        if let data = userDeafault.object(forKey: "child"){
            adult = data as! Int
        }
        if let data = userDeafault.object(forKey: "Infant"){
            adult = data as! Int
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func CustomSegmentedAction(_ sender: CustomSegmentedControl) {
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            print("One way")
        }
        else if sender.selectedSegmentIndex == 1{
            print("Roundtrip")
        }
        else{
            print("Multi-city")
        }

    }
    
    
    @IBAction func DatePickerAction(_ sender: UIButton) {
        
        depatureORreturn = sender.tag
        
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = Date()
            
        //dateRangePickerViewController.selectedEndDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        //dateRangePickerViewController.selectedColor = UIColor.red
        dateRangePickerViewController.title = "Select Date Range"
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
        //UINavigationBar.appearance().backgroundColor = UIColor(red:0.08, green:0.32, blue:0.25, alpha:1.0)
        navigationController.navigationBar.barTintColor = UIColor(red:0.08, green:0.32, blue:0.25, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
    
        
    }
    
    @IBAction func TravellersAction(_ sender: UIButton) {
//        seatTypeLbl.text = seatType
//        travellerLbl.text = String("\(adult)\(child)\(infant) Passengers")
    }
    
    
    // for Generate Serchkey with POST method
    func postActionForSearchKey(){
        let url = URL(string: "http://webapi.bimanholidays.com/flights/searchkey")
        var request = URLRequest(url: url!)
        
        request.setValue("Public MoOdL16tgh", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let FlightInformation: [String: Any] = [
            "SequenceNumber": 0,
            "OriginLocationCode": "DAC",
            "DestinationLocationCode": "CGP",
            "DepartureDateTime": "2019-07-27",
            "ReturnDateTime": "2019-08-05",
            "OriginCity": "Dhaka",
            "DestinationCity": "Chittagong",
            "OriginAirport": "Hazrat Shahjalal International Airport",
            "DestinationAirport": "Shah amanat Int. Airport"
        ]
        
        let TravellersInformation: [String: Any] = [
            "OriginDestinationInformation": [FlightInformation],
            "Adults": adult,
            "Children": child,
            "Infants": infant,
            "TravelClass": seatType,
            "JourneyType": 2
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: TravellersInformation)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else{              // Check for fundamental networking error
                    print("error", error ?? "UnKnown error")
                    return
            }
            guard (200 ... 299) ~= response.statusCode else{
                //check for http errors
                print("status should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("SearchKey responseString = \(responseString)")
            
            let responseData = responseString?.data(using: .utf8)
            let dataDictionary = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableLeaves)
            print(dataDictionary as Any)
            
            if let dataDictionary = dataDictionary as? [String: Any]{
                if let singleData = dataDictionary["Searchkey"] as? String{
                    print("Searchkey is - \(singleData)")
                    self.searchKey = singleData
                    self.postActionForValue()
                }
            }
            do{
                
            }catch let jsonError{
                print("Error Serializing json: ",jsonError)
            }
        }.resume()
    }
    
    // POST method for getting values
    func postActionForValue(){
        let url = URL(string: "http://webapi.bimanholidays.com/flights/search")
        var request = URLRequest(url: url!)
        
        request.setValue("Public MoOdL16tgh", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let FlightInformation: [String: Any] = [
            "SequenceNumber": 0,
            "OriginLocationCode": "DAC",
            "DestinationLocationCode": "CGP",
            "DepartureDateTime": "2019-07-27",
            "ReturnDateTime": "2019-08-05",
            "OriginCity": "Dhaka",
            "DestinationCity": "Chittagong",
            "OriginAirport": "Hazrat Shahjalal International Airport",
            "DestinationAirport": "Shah amanat Int. Airport"
        ]
        
        let TravellersInformation: [String: Any] = [
            "OriginDestinationInformation": [FlightInformation],
            "Adults": adult,
            "Children": child,
            "Infants": infant,
            "TravelClass": seatType,
            "JourneyType": 2,
            "ProviderId": 4,
            "SearchID": searchKey
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: TravellersInformation)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else{              // Check for fundamental networking error
                    print("error", error ?? "UnKnown error")
                    return
            }
            guard (200 ... 299) ~= response.statusCode else{
                //check for http errors
                print("status should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
//            guard responseString != nil else{return}
            print("SearchValue responseString = \(responseString)")
            
//            let responseData = responseString?.data(using: .utf8)
//            let dataDictionary = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableLeaves)
//            print(dataDictionary as Any)
//
//            if let dataDictionary = dataDictionary as? [String: Any]{
//                if let singleData = dataDictionary["Results"] as? [String]{
//                    print("Result is - \(singleData)")
//                    //self.searchKey = singleData
//                }
//            }
            do{
                var myData = try JSONDecoder().decode(Response.self, from: data)
                
                print("mydata : ",myData.Results.SearchRequest)
            }catch let jsonError{
                print("Error Serializing json: ",jsonError)
            }
            }.resume()
    }
    
    
    @IBAction func SearchBtnAction(_ sender: UIButton) {
        postActionForSearchKey()
    }
    
}

// for depature date
extension ViewController : CalendarDateRangePickerViewControllerDelegate {
    func didTapCancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapDoneWithDateRange(startDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        /////
//        let userDefault = UserDefaults()
//        if let data = userDefault.object(forKey: "Date"){
//            if let dataString = data as? String{
//                if depatureORreturn == 1{
//                    //                    ReturnDate = dateFormatter.string(from: dataString)
//                    //                    let returnDateSplit = ReturnDate.characters.split{$0 == ","}.map(String.init)
//                    self.depatureOutlet.text = dataString
//                }
//                else if depatureORreturn == 2{
//                    self.returnLblOutlet.text = dataString
//                }
//                //self.travellerLbl.text = dataString
//            }
//        }
        
        if depatureORreturn == 1{
           //depatureOutlet.text = dateFormatter.string(from: startDate) //+ " to " + dateFormatter.string(from: endDate)

            DepatureDate = dateFormatter.string(from: startDate)
            //print(DepatureDate)
            let depatureDateSplit = DepatureDate.characters.split{$0 == ","}.map(String.init)
            depatureOutlet.text = "\(depatureDateSplit[1]),\(depatureDateSplit[2])"
            print(depatureDateSplit[1], depatureDateSplit[2])
            print(DepatureDate)
        }
        else if depatureORreturn == 2{
            //returnLblOutlet.text = dateFormatter.string(from: startDate) //+ " to " + dateFormatter.string(from: endDate)
            ReturnDate = dateFormatter.string(from: startDate)
            let returnDateSplit = ReturnDate.characters.split{$0 == ","}.map(String.init)
            returnLblOutlet.text = "\(returnDateSplit[1]),\(returnDateSplit[2])"

            print(returnDateSplit[1], returnDateSplit[2])
        }
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}



