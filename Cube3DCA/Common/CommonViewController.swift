//
//  CommonViewController.swift
//  3DCubeWithCA
//
//  Created by Mihaela Mihaljevic Jakic on 03.05.2021..
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

import AllApples

class CommonViewController: AViewController {
  
  // MARK: -
  // MARK: Properties -
  
  private(set) public lazy var cubeView: CACube3DView = {
    let v = CACube3DView(layerName: "Cube 3D View")
    return v
  }()
  
  
  // MARK: -
  // MARK: Life Cycle -
  
  // INFO: Need to create the appropriate `View` type for the OS -
  override func loadView() {
    self.view = self.cubeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // INFO: Need to typecast our view to the appropriate `View` type, which will be resolved at compile time
    if let aView = view as? AView {
      aView.myColor = AColor.black
    }
    
  }

}
