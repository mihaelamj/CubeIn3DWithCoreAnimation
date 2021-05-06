//
//  AppDelegate.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Cocoa
import AllApples

class AppDelegate: NSObject, NSApplicationDelegate {
  private var window: NSWindow?
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    window = AppSceneDelegate.makeWindow_Mac(theVC: CommonViewController())
  }
}

