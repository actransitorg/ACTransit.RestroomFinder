////
////  RestroomRow.swift
////  Restroom
////
////  Created by Aidin on 5/1/20.
////  Copyright © 2020 DevTeam. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//
//
//struct RestroomRow: View {
//    var landmark: RestStopModel
//
//    @available(iOS 13.0.0, *)
//    var body: some View {
//        HStack {
////            landmark.image
////                .resizable()
////                .frame(width: 50, height: 50)
//            Text(landmark.name)
//            Spacer()
//        }
//    }
//}
//
//struct RestroomRow_Previews: PreviewProvider {
//    
//    @available(iOS 13.0.0, *)
//    static var previews: some View {
//        //Text("Hello, " + Data[1])
//        
//        RestroomRow(landmark: restroomData[1])
//    }
//    
//  
//    
//}
//
//
//let restroomData: [RestStopModel] = load("RestroomData")
//
//  func load<T: Decodable>(_ filename: String) -> T {
//      let data: Data
//
//      guard let file = Bundle.main.path(forResource: filename, ofType: "json")
//          else {
//              fatalError("Couldn't find \(filename) in main bundle.")
//      }
//
//      do {
//          data = try Data(contentsOf: URL(fileURLWithPath: file), options: .mappedIfSafe)
//      } catch {
//          fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//      }
//
//      do {
//          let decoder = JSONDecoder()
//          return try decoder.decode(T.self, from: data)
//      } catch {
//          fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//      }
//  }
