//
//  BluetoothViewController.swift
//  Learnings
//
//  Created by Hxtreme on 09/10/23.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: UIViewController {

    var cbCentralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cbCentralManager = CBCentralManager(delegate: self, queue: nil)

        // Do any additional setup after loading the view.
    }
    
}

extension BluetoothViewController :  CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "Colorfit Pro 2" {
            cbCentralManager.stopScan()
            cbCentralManager.connect(peripheral, options: nil)
            self.peripheral = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected : \(peripheral.name ?? "No Name")")
        
        //it' discover all service
        //peripheral.discoverServices(nil)
        
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected : \(peripheral.name ?? "No Name")")
        cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}

//MARK:- CBPeripheralDelegate
extension BluetoothViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    
           if let services = peripheral.services {
               //discover characteristics of services
               for service in services {
                 peripheral.discoverCharacteristics(nil, for: service)
             }
           }
       }    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
          
          if let charac = service.characteristics {
              for characteristic in charac {
                  print("characteristics", characteristic.uuid)
              }
          }
          
      }
}
