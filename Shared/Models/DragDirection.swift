/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Mai Nhung
  ID: s3879954
  Created  date: 15/08/2022
  Last modified: 29/08/2022
  Acknowledgement: Tom Huynh github, canvas 
*/

import Foundation
enum DragDirection: String, CaseIterable {
    case north = "top none", east = "none right", west = "none left", south = "bottom none", northeast = "top right", northwest = "top left", southeast = "bottom right", southwest = "bottom left", none = "none none"
}
