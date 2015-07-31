//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Ruslan Cheshko on 7/30/15.
//  Copyright (c) 2015 Ukrainian.Solutions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func CreateHost(sender: NSButton) {
        println("Hello, world")
    }

    @IBAction func CreateClient(sender: AnyObject) {
        println("Do play client!")
    }
    

}
