//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by Ruslan Cheshko on 7/30/15.
//  Copyright (c) 2015 Ukrainian.Solutions. All rights reserved.
//

import Cocoa

class PlaygroundController: NSViewController {
    
    @IBOutlet weak var Label: NSTextField!
    
    @IBOutlet weak var Cell11: NSButton!
    @IBOutlet weak var Cell12: NSButton!
    @IBOutlet weak var Cell13: NSButton!
    
    @IBOutlet weak var Cell21: NSButton!
    @IBOutlet weak var Cell22: NSButton!
    @IBOutlet weak var Cell23: NSButton!
    
    @IBOutlet weak var Cell31: NSButton!
    @IBOutlet weak var Cell32: NSButton!
    @IBOutlet weak var Cell33: NSButton!
    
    
    var playerTurning: UInt8 = 0
    var playerIAM: UInt8 = 1
    var playground: [UInt8] = []
    
    var cellsEq: [NSButton!] = []
    
    override func viewDidLoad() {
        println("Playground controller was loaded")
        // Do any additional setup after loading the view.
        
        self.cellsEq = [Cell11, Cell12, Cell13,
                        Cell21, Cell22, Cell23,
                        Cell31, Cell32, Cell33]
        
        Label.stringValue = "Wait client response"
        let buffer = Server.waitDataFromClient()
        println("Playground", buffer)
        Label.stringValue = "You turn"
        self.playerTurning = buffer[1]
        println(playerTurning)
        if playerTurning == 1 {
            println("Norm")
        } else {
            println("Ne norm")
        }
        
        self.playground = Array(buffer[2..<11])
        
        self.drawPlayground()
        
    }
    
    var i = -1
    func check(value:UInt8, sender: NSButton) -> UInt8 {
        i = i+1
        let cell = self.cellsEq[i]
        let playValue = self.playground[i]
        if cell == sender {
            if playValue == 0 {
                return self.playerIAM
            } else {
                println("You cant step this")
                return value
            }
        }
        
        return value
    }
    
    @IBAction func ButtonClicked(sender: NSButton) {
        if self.playerTurning != self.playerIAM {
            println("Its not you turn")
            return
        }
        
        let newPlayground = playground.map { self.check($0, sender: sender) }
        self.i = -1
        if self.playground == newPlayground {
            println("Playground the same")
        } else {
            self.playground = newPlayground
            if playerIAM == 1 {
                self.playerTurning = 2
            } else {
                self.playerTurning = 1
            }
            self.drawPlayground()
            Label.stringValue = "Opponent turn. Waiting..."
            
            self.sendAndWait()
        }
        
    }
    
    func sendAndWait() {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            Socket.writeData(Server.acceptClient, data: NSData(bytes: [0xFF, self.playerTurning] + self.playground, length: 11))

            let response = Server.waitDataFromClient()
            println("RESPONSE", response)
            dispatch_async(dispatch_get_main_queue()) {
                self.Label.stringValue = "You turn"
                self.playground = Array(response[2..<11])
                self.playerTurning = self.playerIAM
                self.drawPlayground()
            }
        })

    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    internal func drawPlayground() {
        for (index, value) in enumerate(self.playground) {
            let cell = self.cellsEq[index]
            if value == 0 {
                cell.title = ""
            } else if value == 1 {
                cell.title = "X"
            } else if value == 2 {
                cell.title = "O"
            } else {
                cell.title = "!!!"
            }
            
        }
    }
    
    @IBAction func CancelPlayground(sender: AnyObject) {
        Server.stop()
        self.dismissViewController(self)
    }
}

