//
//  ViewController.swift
//  blackwidow
//
//  Created by Anton Verinov on 11.04.15.
//  Copyright (c) 2015 ifelse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GCKDeviceScannerListener, UITableViewDelegate, UITableViewDataSource {
    var deviceScanner = GCKDeviceScanner()

    @IBOutlet weak var castButton: UIButton!
    @IBOutlet weak var castDevicesTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        castDevicesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "device")

        deviceScanner.addListener(self)
        deviceScanner.startScan()
        
        if deviceScanner.devices.count > 0 {
            castButton.hidden = false
        }
//        self.deviceScanner.stopScan();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toggleCastDevices(sender: UIButton) {
        castDevicesTable.hidden = !castDevicesTable.hidden
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceScanner.devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deviceCell = UITableViewCell()
        deviceCell.textLabel?.text = deviceScanner.devices[indexPath.row].friendlyName
        return deviceCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(deviceScanner.devices[indexPath.row].friendlyName)
        // connect
        castDevicesTable.hidden = !castDevicesTable.hidden
    }

    // MARK: GCKDeviceScannerListener

    func deviceDidComeOnline(device: GCKDevice!) {
        println("Chromecast found '\(device.friendlyName)'")
        castButton.hidden = false
        castDevicesTable.reloadData()
        //[self.deviceTableView reloadData];
    }
    
    func deviceDidGoOffline(device: GCKDevice!) {
        castButton.hidden = true
        castDevicesTable.reloadData()
//        deviceScanner.stopScan()
        println("Chromecast lost '\(device.friendlyName)'")
    }

    func deviceDidChange(device: GCKDevice!) {
        castDevicesTable.reloadData()
        println("Chromecast changed '\(device.friendlyName)'")
    }
}