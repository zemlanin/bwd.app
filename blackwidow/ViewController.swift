//
//  ViewController.swift
//  blackwidow
//
//  Created by Anton Verinov on 11.04.15.
//  Copyright (c) 2015 ifelse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GCKDeviceScannerListener, GCKDeviceManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    var deviceScanner: GCKDeviceScanner?
    var deviceManager: GCKDeviceManager?
    var chromeCastKey = "0A4300E2"
    
    private lazy var textChannel: SenderChannel = {
        return SenderChannel(namespace: "urn:x-cast:blackwidow")
    }()
    private var selectedDevice:GCKDevice?

    @IBOutlet weak var castButton: UIButton!
    @IBOutlet weak var castDevicesTable: UITableView!
    @IBOutlet weak var msgButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        castDevicesTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "device")
        
        deviceScanner = GCKDeviceScanner.init(filterCriteria: GCKFilterCriteria(forAvailableApplicationWithID: chromeCastKey))

        deviceScanner!.addListener(self)
        deviceScanner!.startScan()
        
        if deviceScanner!.devices.count > 0 {
            castButton.hidden = false
        }

//        signIn?.signIn()
//        self.deviceScanner.stopScan();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toggleCastDevices(sender: UIButton) {
        castDevicesTable.hidden = !castDevicesTable.hidden
    }

    @IBAction func sendMessage(sender: UIButton) {
        if (deviceManager == nil || deviceManager!.connectionState != GCKConnectionState.Connected) {
            print("disconnected")
            return
        }
        print("ping")
        textChannel.sendTextMessage("\"ping\"")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = deviceScanner?.devices.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deviceCell = UITableViewCell()
        deviceCell.textLabel?.text = deviceScanner?.devices[indexPath.row].friendlyName
        return deviceCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedDevice = deviceScanner?.devices[indexPath.row] as? GCKDevice
        
        deviceManager = GCKDeviceManager(device: selectedDevice, clientPackageName: NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as! String)
        deviceManager!.delegate = self
        deviceManager!.connect()
    }
    
    // MARK: GCKDeviceManagerDelegate
    
    func deviceManager(deviceManager: GCKDeviceManager!,
        didConnectToCastApplication
        applicationMetadata: GCKApplicationMetadata!,
        sessionID: String!,
        launchedApplication: Bool) {
            print("Application has launched.");
            deviceManager.addChannel(self.textChannel)
    }

    func deviceManagerDidConnect(deviceManager: GCKDeviceManager!) {
        print("connected")
        self.deviceManager?.launchApplication(chromeCastKey)
        castDevicesTable.hidden = !castDevicesTable.hidden
        msgButton.hidden = false
    }
    
    func deviceManager(deviceManager: GCKDeviceManager!,
        didFailToConnectToApplicationWithError error: NSError!) {
            print("Received notification that device failed to connect to application.")
    }
    
    func deviceManager(deviceManager: GCKDeviceManager!,
        didFailToConnectWithError error: NSError!) {
            print("Received notification that device failed to connect.")
    }
    
    func deviceManager(deviceManager: GCKDeviceManager!,
        didDisconnectWithError error: NSError!) {
            print("Received notification that device disconnected.")
    }

    // MARK: GCKDeviceScannerListener

    func deviceDidComeOnline(device: GCKDevice!) {
        print("Chromecast found '\(device.friendlyName)'")
        castButton.hidden = false
        castDevicesTable.reloadData()
        //[self.deviceTableView reloadData];
    }
    
    func deviceDidGoOffline(device: GCKDevice!) {
        castButton.hidden = true
        castDevicesTable.reloadData()
//        deviceScanner.stopScan()
        print("Chromecast lost '\(device.friendlyName)'")
    }
}