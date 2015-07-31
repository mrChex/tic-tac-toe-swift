//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Ruslan Cheshko on 7/30/15.
//  Copyright (c) 2015 Ukrainian.Solutions. All rights reserved.
//

import Cocoa

class ConnectController: NSViewController {
    
    override func viewDidLoad() {
        println("HostCreate controller was loaded")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear() {
        println("View did appear")
        Server.start()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            Server.waitForClient()
            dispatch_async(dispatch_get_main_queue()) {
                
                let view = self.storyboard?.instantiateControllerWithIdentifier("ViewController") as! ViewController
                self.performSegueWithIdentifier("testmo", sender: self)
                println("seque done")
                
            }
        })
        
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

