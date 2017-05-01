//
//  PropertyModel.swift
//  Nobroker
//
//  Created by Sanjay Mali on 30/04/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import Foundation
import SwiftyJSON
class PropertyModel{
    var street:String?
    var furnishing:String?
    var rent:Int?
    var propertyTitle:String?
    var propertySize:Int?
    var secondaryTitle:String?
    required init(json:JSON) {
        self.street = json["street"].string
        self.furnishing = json["furnishing"].string
        self.rent  = json["rent"].int
        self.propertyTitle = json["propertyTitle"].string
        self.propertySize = json["propertySize"].int
        self.secondaryTitle = json["secondaryTitle"].string
    }
    /*
     "street":"Near The Koramangala Club",
     "score":{},
     "propertyAge":14,
     "latitude":12.93883635939715,
     "shortlistedByLoggedInUser":false,
     "parking":"BOTH",
     "totalFloor":1,
     "furnishing":"SEMI_FURNISHED",
     "active":true,
     "shortUrl":"http:\/\/nobrkr.in\/fhgIDP",
     "buildingType":"IF",
     "lift":false,
     "weight":45.5,
     "id":"ff8081815b2cb5e4015b2d1ade991267",
     "adminEvent":"PROPERTY",
     "deposit":400000,
     "buildingId":null,
     "builderName":null,
     "furnishingDesc":"Semi",
     "society":"Standalone building",
     "dateOnly":1491676200000,
     "title":"3 BHK in Kormangala",
     "rent":40000,
     "leaseType":"FAMILY",
     "longitude":77.62540805662229,
     "forLease":false,
     "amenities":"{\"LIFT\":false,\"GYM\":false,\"INTERNET\":false,\"AC\":true,\"CLUB\":false,\"INTERCOM\":false,\"POOL\":false,\"CPA\":false,\"FS\":false,\"SERVANT\":false,\"SECURITY\":false,\"SC\":true,\"GP\":false,\"PARK\":true,\"RWH\":true,\"STP\":false,\"HK\":false,\"PB\":false,\"VP\":true}",
     "description":"A 3 BHK independent House (1800 Sq.ft.) on a 60ft. x 40ft. Plot with all modern amenities, facing 60ft. Main Road in 6th Block Koramangala, available for Rent for purely Residential purposes for families.\nKey features: Large Spacious Hall (Living Cum Dining Room), 3 Spacious Bed Rooms with attached fully tiled Bathrooms with all Modern (Jaguar) fittings,Well appointed modern Kitchen complete with Electric Chimney, Exhaust Fan and Ceiling Fan, Full Granite Flooring for the entire House, 24x7 Hot water supply from Roof Mounted Solar Water Heaters and backup Electric Water Heaters (Geysers) in all Bath Rooms, Full 100% Teak Woodwork with Large French Windows and Double Shutters for Mosquito proofing, Generous Light fittings with CFL luminaries with a large no. of electrical outlet points for all conceivable equipment\/gadgets like A\/c, TV, Home Audio and Video, Refrigerator, Washing Machine,Plug & Play Inverter Point, All modern Kitchen Gadgets, etc.. . , Fully Modular Anchor Croma Switches, Adequate No. of Ceiling Fans in all areas including Kitchen, Utility and Wash areas, Pre wired Satellite TV, Telephone and Internet Points, Large Patio \/ Sit out, Car Parking.\nGenuinely Interested for their own use,",
     "negotiable":false,
     "detailUrl":"\/property\/3-BHK-apartment-for-rent-in-Kormangala-bangalore-for-rs-40000\/ff8081815b2cb5e4015b2d1ade991267\/detail",
     "type":"BHK3",
     "location":"12.938836359397145000,77.625408056622290000",
     "bathroom":3,
     "propertyCode":"NB-2762",
     "propertyType":"RENT",
     "ownerName":"Srinivasan",
     "parkingDesc":"Both",
     "localityId":"ChIJj4uexEQUrjsRu4TxdrQAEnw",
     "loanAvailable":true,
     "propertyTitle":"3 BHK in Kormangala",
     "accomodationType":null,
     "buildingName":null,
     "cupBoard":3,
     "managed":null,
     "availableFrom":1493058600000,
     "activationDate":1491716745000,
     "floor":1,
     "ownerId":"ff8081814d6c3d8d014d6fff5d900e44",
     "swimmingPool":false,
     "waterSupply":"CORPORATION",
     "powerBackup":"None",
     "inactiveReason":null,
     "nbLocality":"Kormangala",
     "propertySize":1700,
     "facingDesc":"South-East",
     "typeDesc":"3 BHK",
     "sponsored":true,
     "balconies":1,
     "lastUpdateDate":1491724235000,
     "secondaryTitle":"Standalone building, Near The Koramangala Club",
     "accomodationTypeDesc":"",
     "facing":"SE",
     "locality":"Kormangala",
     "tenantTypeDesc":"",
     "city":"bangalore",
     "photoAvailable":true,
     "gym":false,
     "creationDate":1491110387000,
     "accurateLocation":true,
     "pinCode":560095,
     "photos":[],
     "sharedAccomodation":false,
     "amenitiesMap":{}
    */
    
}
