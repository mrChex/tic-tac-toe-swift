//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Ruslan Cheshko on 7/30/15.
//  Copyright (c) 2015 Ukrainian.Solutions. All rights reserved.
//


import Cocoa


class HostCreateController: NSViewController {
    @IBOutlet weak var IPLabel: NSTextField!
    
    override func viewDidLoad() {
        println("HostCreate controller was loaded")
        super.viewDidLoad()
        IPLabel.stringValue = "IP: " + String(stringInterpolationSegment: getIFAddresses())
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear() {
        println("View did appear")
        println(self.getIFAddresses())
        Server.start()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            Server.waitForClient()
            dispatch_async(dispatch_get_main_queue()) {
    
                let view = self.storyboard?.instantiateControllerWithIdentifier("ViewController") as! ViewController
                self.performSegueWithIdentifier("testmo", sender: view)
                println("seque done")
    
            }
        })

    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String.fromCString(hostname) {
                                    addresses.append(address)
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    
    @IBAction func CancelHost(sender: AnyObject) {
        Server.stop()
        self.dismissViewController(self)
    }
    
}

