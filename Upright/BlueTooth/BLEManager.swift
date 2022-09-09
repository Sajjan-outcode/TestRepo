//
//  BLEManager.swift
//  Upright
//
//  Created by USS - Software Dev on 4/6/22.
//

import Foundation

import CoreBluetooth



class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    /* VSI Constants */
    let deviceName = "VSI"
    let vsiServiceUUID = CBUUID(string: "2ac4c066-a7cc-11ec-b909-0242ac120002")
    let stateUUID = CBUUID(string: "ff01")
    let commandUUID = CBUUID(string: "ff02")
    let responseUUID = CBUUID(string: "ff03")
    let scanIndexUUID = CBUUID(string: "ff04")
    let scanLengthUUID = CBUUID(string: "ff05")
    let scanXUUID = CBUUID(string: "ff06")
    let scanYUUID = CBUUID(string: "ff07")
    let scanHeightUUID = CBUUID(string: "ff08")
    let probeTypeUUID = CBUUID(string: "ff09")
    let deviceHeightMSBUUID = CBUUID(string: "ff0a")
    let deviceHeightLSBUUID = CBUUID(string: "ff0b")
    let scanSpeedUUID = CBUUID(string: "ff0c")
    let scanPressureUUID = CBUUID(string: "ff0d")
    let scanResolutionUUID = CBUUID(string: "ff0e")
    
    //let commHome            = 1
    //let commInit            = 2
    //let commDetect          = 3
    //let commScan            = 4
    //let commPause           = 5
    //let commResume          = 6
    //let commKill            = 127
    
    let commands:[(command: UInt8, commandStr: String)] =   [(1, "Home"),
                                                             (2, "Initialize"),
                                                             (3, "Detect"),
                                                             (4, "Scan"),
                                                             (5, "Stop"),
                                                             (6, "Resume"),
                                                             (7, "Setup"),
                                                             (127, "Kill")]
    /*let commands: [CommandTextPair] = [ CommandTextPair(command: 1, commandStr: "Home"),
                                        CommandTextPair(command: 2, commandStr: "Initialize"),
                                        CommandTextPair(command: 3, commandStr: "Detect"),
                                        CommandTextPair(command: 4, commandStr: "Scan"),
                                        CommandTextPair(command: 5, commandStr: "Pause"),
                                        CommandTextPair(command: 6, commandStr: "Resume"),
                                        CommandTextPair(command: 127, commandStr: "Kill")]*/
    

    
    let responses:[(response: UInt8, responseStr: String)] =   [(1, "OK"),
                                                                (2, "INVALID STATE"),
                                                                (3, "INVALID PARAM"),
                                                                (4, "SCAN DATA NOT READY"),
                                                                (5, "INVALID INDEX")]
    
    

    
    let stateHoming: UInt8          = 1
    let stateHomed: UInt8           = 2
    let stateInitializing: UInt8    = 3
    let stateInitialized: UInt8     = 4
    let stateDetecting: UInt8       = 5
    let stateDetected: UInt8        = 6
    let stateScanning: UInt8        = 7
    let stateScanned: UInt8         = 8
    let stateDataTransfered: UInt8    = 9
    let stateStopped: UInt8         = 10
    let stateIndeterminate: UInt8   = 11
    let stateUserNotDetect: UInt8   = 12
    let stateCalibrating: UInt8        = 13
    let stateSetup: UInt8            = 14
    let stateGantryObstruction        = 125
    let stateProbeObstruction        = 126
    let stateSystemFault: UInt8     = 127
    
    /* VSI Variables */
    private var myCentral: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    private var stateChar : CBCharacteristic?
    private var commandChar : CBCharacteristic?
    private var responseChar :CBCharacteristic?
    private var scanIndexChar :CBCharacteristic?
    private var scanLengthChar : CBCharacteristic?
    private var scanXChar : CBCharacteristic?
    private var scanYChar : CBCharacteristic?
    private var scanHeightChar : CBCharacteristic?
    private var probeTypeChar : CBCharacteristic?
    private var deviceHeightMSBChar : CBCharacteristic?
    private var deviceHeightLSBChar : CBCharacteristic?
    private var scanSpeedChar : CBCharacteristic?
    private var scanPressureChar : CBCharacteristic?
    private var scanResolutionChar : CBCharacteristic?
    
    @Published private var isSupported = true
    @Published private var isAllowed = true
    @Published private var switchedOn = true
    @Published private var connected = false
    
    @Published private var vsiState: UInt8 = 0
    @Published private var vsiResponse: UInt8 = 0
    @Published private var vsiLength: UInt8 = 0
    @Published private var vsiIndex: UInt8 = 0
    @Published private var vsiX: UInt32 = 0
    @Published private var vsiY: UInt32 = 0
    @Published private var vsiHeight: UInt32 = 0
    @Published private var vsiHeightMSB: UInt8 = 0
    @Published private var vsiHeightLSB: UInt8 = 0
    @Published private var vsiProbeType: UInt8 = 0
    @Published private var vsiDeviceHeight: UInt32 = 0
    @Published private var vsiScanSpeed: UInt8 = 0
    @Published private var vsiScanPressure: UInt8 = 0
    @Published private var vsiScanResolution: UInt8 = 0
    
    private var X_array:Array<Int>? = []
    private var Y_array:Array<Int>? = []
    
    /**
     *  @method initWithDelegate:queue:
     *
     *  @param delegate The delegate that will receive central role events.
     *  @param queue    The dispatch queue on which the events will be dispatched.
     *
     *  @discussion     The initialization call. The events of the central role will be dispatched on the provided queue.
     *                  If <i>nil</i>, the main queue will be used.
     *
     */
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    
    /*!
     *  @method centralManagerDidUpdateState:
     *
     *  @param central  The central manager whose state has changed.
     *
     *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
     *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
     *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
     *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
     *                  manager become invalid and must be retrieved or discovered again.
     *
     *  @see            state
     *
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            switchedOn = true
        }
        else {
            switchedOn = false
        }
        
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            connected = false
            print("central.state is .resetting")
        case .unsupported:
            isSupported = false
            connected = false
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
            isAllowed = false
            connected = false
        case .poweredOff:
            switchedOn = false
            connected = false
            print("central.state is .poweredOff")
        case .poweredOn:
            switchedOn = true
            print("central.state is .poweredOn")
        @unknown default:
            return
        }

    }
    
    
    /*!
     *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:
     *
     *  @param central              The central manager providing this update.
     *  @param peripheral           A <code>CBPeripheral</code> object.
     *  @param advertisementData    A dictionary containing any advertisement and scan response data.
     *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
     *                                was not available.
     *
     *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
     *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
     *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
     *
     *  @seealso                    CBAdvertisementData.h
     *
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            if name == deviceName {
                self.peripheral = peripheral
                self.peripheral.delegate = self
                myCentral.connect(self.peripheral, options: nil)
            }
        }
        else {
            
        }
    }
    
    
    /*!
     *  @method centralManager:didConnectPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that has connected.
     *
     *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
     *
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connected = true
        stopScanning()
        self.peripheral.discoverServices(nil)
    }
    
    
    /*!
     *  @method centralManager:didDisconnectPeripheral:
     *
     *  @param central      The central manager providing this information.
     *  @param peripheral   The <code>CBPeripheral</code> that has connected.
     *
     *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
     *
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected = false
        myCentral.scanForPeripherals(withServices: [vsiServiceUUID], options: nil)
        print("Disconnected")
    }
    
    
    
    /*!
     *  @method peripheral:didDiscoverServices:
     *
     *  @param peripheral    The peripheral providing this information.
     *    @param error        If an error occurred, the cause of the failure.
     *
     *  @discussion            This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
     *                        <i>peripheral</i>'s @link services @/link property.
     *
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
           // print(service)
            self.peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    
    /*!
     *  @method peripheral:didDiscoverCharacteristicsForService:error:
     *
     *  @param peripheral    The peripheral providing this information.
     *  @param service        The <code>CBService</code> object containing the characteristic(s).
     *    @param error        If an error occurred, the cause of the failure.
     *
     *  @discussion            This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
     *                        they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            switch characteristic.uuid {
            case stateUUID:
                stateChar = characteristic
                self.peripheral.setNotifyValue(true, for: stateChar!)
                self.peripheral.readValue(for: characteristic)
            case commandUUID:
                commandChar = characteristic
            case responseUUID:
                responseChar = characteristic
                self.peripheral.setNotifyValue(true, for: responseChar!)
                self.peripheral.readValue(for: characteristic)
            case scanIndexUUID:
                scanIndexChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanIndexChar!)
                self.peripheral.readValue(for: characteristic)
            case scanLengthUUID:
                scanLengthChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanLengthChar!)
                self.peripheral.readValue(for: characteristic)
            case scanXUUID:
                scanXChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanXChar!)
                self.peripheral.readValue(for: characteristic)
            case scanYUUID:
                scanYChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanYChar!)
                self.peripheral.readValue(for: characteristic)
            case scanHeightUUID:
                scanHeightChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanHeightChar!)
                self.peripheral.readValue(for: characteristic)
            case probeTypeUUID:
                probeTypeChar = characteristic
                self.peripheral.setNotifyValue(true, for: probeTypeChar!)
                self.peripheral.readValue(for: characteristic)
            case deviceHeightMSBUUID:
                deviceHeightMSBChar = characteristic
                self.peripheral.setNotifyValue(true, for: deviceHeightMSBChar!)
                self.peripheral.readValue(for: characteristic)
            case deviceHeightLSBUUID:
                deviceHeightLSBChar = characteristic
                self.peripheral.setNotifyValue(true, for: deviceHeightLSBChar!)
                self.peripheral.readValue(for: characteristic)
            case scanSpeedUUID:
                scanSpeedChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanSpeedChar!)
                self.peripheral.readValue(for: characteristic)
            case scanPressureUUID:
                scanPressureChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanPressureChar!)
                self.peripheral.readValue(for: characteristic)
            case scanResolutionUUID:
                scanResolutionChar = characteristic
                self.peripheral.setNotifyValue(true, for: scanResolutionChar!)
                self.peripheral.readValue(for: characteristic)
            default: break
            }
            //print(characteristic)
            self.peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    
    /*!
     *  @method peripheral:didDiscoverDescriptorsForCharacteristic:error:
     *
     *  @param peripheral        The peripheral providing this information.
     *  @param characteristic    A <code>CBCharacteristic</code> object.
     *    @param error            If an error occurred, the cause of the failure.
     *
     *  @discussion                This method returns the result of a @link discoverDescriptorsForCharacteristic: @/link call. If the descriptors were read successfully,
     *                            they can be retrieved via <i>characteristic</i>'s <code>descriptors</code> property.
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {

    }
    
    
    /*!
     *  @method peripheral:didUpdateValueForCharacteristic:error:
     *
     *  @param peripheral        The peripheral providing this information.
     *  @param characteristic    A <code>CBCharacteristic</code> object.
     *    @param error            If an error occurred, the cause of the failure.
     *
     *  @discussion                This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {

        switch characteristic.uuid {
        case stateUUID:
            vsiState = characteristic.value?.first ?? 0
            
        case responseUUID:
            vsiResponse = characteristic.value?.first ?? 0
            
        case scanLengthUUID:
            vsiLength = characteristic.value?.first ?? 0

        case scanIndexUUID:
            vsiIndex = characteristic.value?.first ?? 0

        case scanXUUID:
            guard let xCountBytes = scanXChar?.value?.count else {break}
            if (xCountBytes != 4) {
               // print(xCountBytes)
                break
            }
            vsiX = 0
            var shift = 24
            scanXChar?.value?.forEach { byte in
                vsiX += UInt32(byte) << shift
                shift -= 8
            }
            self.X_array?.append(Int(vsiX) / 10)

        case scanYUUID:
            guard let yCountBytes = scanYChar?.value?.count else {break}
            if (yCountBytes != 4) {
               // print(yCountBytes)
                break
            }
            vsiY = 0
            var shift = 24
            scanYChar?.value?.forEach { byte in
                vsiY += UInt32(byte) << shift
                shift -= 8
            }
            self.Y_array?.append(Int(vsiY) / 10)

        case scanHeightUUID:
            guard let heightCountBytes = scanHeightChar?.value?.count else {break}
            if (heightCountBytes != 4) {
               // print(heightCountBytes)
                break
            }
            vsiHeight = 0
            var shift = 24
            scanHeightChar?.value?.forEach { byte in
                vsiHeight += UInt32(byte) << shift
                shift -= 8
            }

        case probeTypeUUID:
            vsiProbeType = characteristic.value?.first ?? 0
            
        case deviceHeightMSBUUID:
            vsiHeightMSB = characteristic.value?.first ?? 0
            
        case deviceHeightLSBUUID:
            vsiHeightLSB = characteristic.value?.first ?? 0
            
        case scanSpeedUUID:
            vsiScanSpeed = characteristic.value?.first ?? 0
        
        case scanPressureUUID:
            vsiScanPressure = characteristic.value?.first ?? 0
            
        case scanResolutionUUID:
            vsiScanResolution = characteristic.value?.first ?? 0
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
    
    /*!
     *  @method connect
     *
     *  @discussion                 Starts scanning for a peripheral advertising the VSI Service and connect
     */
    func connect() {
        if (switchedOn) {
            print("startScanning")
            myCentral.scanForPeripherals(withServices: [vsiServiceUUID], options: nil)
        }
        else {
            print("Bluetooth Not Available")
        }
    }
    
    
    /*!
     *  @method disconnect
     *
     *  @discussion                 Disconnects from the VSI
     */
    func disconnect() {
        myCentral.cancelPeripheralConnection(peripheral)
        connected = false
        print("User disconnected")
    }
    
    
    /*!
     *  @method stopScanning
     *
     *  @discussion                 Stops scanning for peripherals after connected to the VSI
     */
    private func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    

    /*!
     *  @method isConnected
     *
     *  @discussion                 Returns the state of connection to the VSI
     */
    func isConnected() -> Bool {
        return connected
    }
    
    
    /*!
     *  @method isSwitchedOn
     *
     *  @discussion                 Returns the state of bluetooth connectivity.  False if bluetooth is disabled or the app does not have permission
     */
    func isSwitchedOn() -> Bool {
        return switchedOn
    }
    
    
    /*!
     *  @method getState
     *
     *  @discussion                 Returns the state of the VSI
     */
    func getState() -> UInt8 {
        return vsiState
    }
    
    
    /*!
     *  @method sendCommand
     *
     *  @param newCommand           The VSI command code
     *  @discussion                 Sends a command to the VSI
     */
    func sendCommand(newCommand: UInt8) {
        if peripheral.state == CBPeripheralState.disconnected {
            connected = false
            return
        }
        let newCommandData = Data(bytes: [newCommand] as [UInt8], count: 1)
            peripheral.writeValue(newCommandData, for: commandChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
     *  @method getResponse
     *
     *  @discussion                 Returns the VSI response to the last command sent
     */
    func getResponse() -> UInt8 {
        guard let currentResponse = responseChar?.value?.first else {return 0}
        return currentResponse
    }
    
    
    /*!
     *  @method getLength
     *
     *  @discussion                 Returns length of the scan data array
     */
    func getLength() -> UInt8 {
        return vsiLength
    }
    
    
    /*!
     *  @method sendScanIndex
     *
     *  @param newIndex             The VSI scan index value
     *  @discussion                 Sends a command to the VSI
     */
    func sendScanIndex (newIndex: UInt8) {
        let scanIndex = NSData(bytes: [newIndex] as [UInt8], length: 1)
        peripheral.writeValue(scanIndex as Data, for: scanIndexChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
     *  @method getScanIndex
     *
     *  @discussion                 Returns the current scan index
     */
    func getScanIndex () -> UInt8 {
        return vsiIndex
    }
    
    
    /*!
     *  @method getX
     *
     *  @discussion                 Returns the x-coordinate of the scan at the current index
     */
    func getX() -> UInt32 {
        return vsiX
    }
    
    
    /*!
     *  @method getY
     *
     *  @discussion                 Returns the y-coordinate of the scan at the current index
     */
    func getY() -> UInt32 {
        return vsiY
    }
    
    
     /*!
     *  @method getHeight
     *
     *  @discussion                 Returns the scan height in mm.
     */
    func getHeight() -> UInt32 {
        return vsiHeight
    }
    
    func getX_array() -> Array<Int> {
        return X_array!
    }
    
    func getY_array() -> Array<Int> {
        return Y_array!
    }
    
    
     /*!
     *  @method sendProbeType
     *
     *  @param newProbeType         The VSI probe type being used
     *  @discussion                 Sends the probe type to the VSI
     */
    func sendProbeType (newProbeType: UInt8) {
        let probeType = NSData(bytes: [newProbeType] as [UInt8], length: 1)
        peripheral.writeValue(probeType as Data, for: probeTypeChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
    *  @method getProbeType
    *
    *  @discussion                 Returns the VSI probe type.
    */
   func getProbeType() -> UInt8 {
       return vsiProbeType
   }
    
    
     /*!
     *  @method sendDeviceHeight
     *
     *  @param newDeviceHeight      The VSI device height, measured from the floor to the bottom of the device in mm
     *  @discussion                 Sends the device height to the VSI
     */
    func sendDeviceHeightMSB (newDeviceHeightMSB: UInt8) {
        let newDeviceHeightData = Data(bytes: [newDeviceHeightMSB], count: 1)
            peripheral.writeValue(newDeviceHeightData, for: deviceHeightMSBChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
    *  @method sendDeviceHeight
    *
    *  @param newDeviceHeight      The VSI device height, measured from the floor to the bottom of the device in mm
    *  @discussion                 Sends the device height to the VSI
    */
   func sendDeviceHeightLSB (newDeviceHeightLSB: UInt8) {
       let newDeviceHeightData = Data(bytes: [newDeviceHeightLSB], count: 1)
           peripheral.writeValue(newDeviceHeightData, for: deviceHeightLSBChar!, type: CBCharacteristicWriteType.withResponse)
   }
    
    
    /*!
    *  @method sendDeviceHeight
    *
    *  @param newDeviceHeight      The VSI device height, measured from the floor to the bottom of the device in mm
    *  @discussion                 Sends the device height to the VSI
    */
   func sendDeviceHeight (newDeviceHeight: UInt32) {
       
       sendDeviceHeightMSB(newDeviceHeightMSB: UInt8(newDeviceHeight >> 8))
       sendDeviceHeightLSB(newDeviceHeightLSB: UInt8(newDeviceHeight))
   }
    
    /*!
    *  @method getDeviceHeight
    *
    *  @discussion                 Returns the VSI device mounting height in mm.
    */
   func getDeviceHeight() -> UInt32 {
       vsiDeviceHeight = 0
       vsiDeviceHeight += UInt32(vsiHeightMSB) << 8
       vsiDeviceHeight += UInt32(vsiHeightLSB)
       return vsiDeviceHeight
   }
    
    
     /*!
     *  @method sendScanSpeed
     *
     *  @param newScanSpeed         The VSI scanning speed (1-5, 1 is the slowest)
     *  @discussion                 Sends the scanning speed to the VSI
     */
    func sendScanSpeed (newScanSpeed: UInt8) {
        let scanSpeed = NSData(bytes: [newScanSpeed] as [UInt8], length: 1)
        peripheral.writeValue(scanSpeed as Data, for: scanSpeedChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
    *  @method getScanSpeed
    *
    *  @discussion                 Returns the VSI scanning speed.
    */
   func getScanSpeed() -> UInt8 {
       return vsiScanSpeed
   }
    
    
     /*!
     *  @method sendPressure
     *
     *  @param newPressure          The VSI scanning pressure (1-5, 1 is the weakest)
     *  @discussion                 Sends the scanning pressure to the VSI
     */
    func sendPressure (newPressure: UInt8) {
        let scanPressure = NSData(bytes: [newPressure] as [UInt8], length: 1)
        peripheral.writeValue(scanPressure as Data, for: scanPressureChar!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    /*!
    *  @method getScanPressure
    *
    *  @discussion                 Returns the VSI scanning pressure.
    */
   func getScanPressure() -> UInt8 {
       return vsiScanPressure
   }
    
    /*!
    *  @method sendResolution
    *
    *  @param newResolution          The VSI scanning resolution (1-255 {millimeters} 1 is the weakest)
    *  @discussion                 Sends the scanning resolution to the VSI
    */
   func sendResolution (newResolution: UInt8) {
       let scanResolution = NSData(bytes: [newResolution] as [UInt8], length: 1)
       peripheral.writeValue(scanResolution as Data, for: scanResolutionChar!, type: CBCharacteristicWriteType.withResponse)
   }
   
   
   /*!
   *  @method getScanResolution
   *
   *  @discussion                 Returns the VSI scanning resolution.
   */
  func getScanResolution() -> UInt8 {
      return vsiScanResolution
  }
    
    /*!
     *  @method getStateString
     *
     *  @discussion                 Returns a string representation of the VSI state
     */
    func getStateString() -> String {
        switch (vsiState) {
        case stateHoming:
            return "Homing"
        case stateHomed:
            return "Homed"
        case stateInitializing:
            return "Initializing"
        case stateInitialized:
            return "Initialized"
        case stateDetecting:
            return "Detecting"
        case stateDetected:
            return "Detected"
        case stateScanning:
            return "Scanning"
        case stateScanned:
            return "Scanned"
        case stateStopped:
            return "Stopped"
        case stateIndeterminate:
            return "Indeterminate"
        case stateUserNotDetect:
            return "User Not Detected"
        case stateSetup:
            return "Setup Mode"
        case stateSystemFault:
            return "SYSTEM FAULT!"
        default:
            return ""
        }
    }
    

    /*!
     *  @method printCharacteristics
     *
     *  @discussion                 Prints the discovered characteristics to the terminal
     */
    private func printCharacteristics() {
        print(stateChar ?? "No Characteristic Data!")
        print(commandChar ?? "No Characteristic Data!")
        print(responseChar ?? "No Characteristic Data!")
        print(scanIndexChar ?? "No Characteristic Data!")
        print(scanLengthChar ?? "No Characteristic Data!")
        print(scanXChar ?? "No Characteristic Data!")
        print(scanYChar ?? "No Characteristic Data!")
    }
    
    func clearArray() {
        X_array = []
        Y_array = []
    }
}
