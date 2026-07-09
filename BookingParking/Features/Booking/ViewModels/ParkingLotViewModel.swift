
import Foundation

@Observable
final class ParkingLotViewModel {
    let mall: MallLocation

    var floorMap: FloorMap
    var selectedSlotID: String?

    var selectedDate: Date
    var startTime: Date
    var endTime: Date
    
    var hasSetStartTime = false
    var hasSetEndTime = false

    // Layout untuk render (grid), dipisah dari data status
    let sections: [SlotSection]
    
    let startBookingTime = 10
    let endBookingTime = 23

    init(mall: MallLocation,
         initialDate: Date = Date(),
         initialStart: Date = Date(),
         initialEnd: Date = Date().addingTimeInterval(3600),
         initialSlotID: String? = nil) {
            self.mall = mall
            self.sections = ParkingLotViewModel.buildLayout()
            self.floorMap = ParkingLotViewModel.mockFloorMap()
            self.selectedDate = initialDate
            self.startTime = initialStart
            self.endTime = initialEnd
            self.selectedSlotID = initialSlotID
    }

    var canReserve: Bool {
        selectedSlotID != nil && hasSetStartTime && hasSetEndTime
    }
    
    func operationalStartHour(){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        
        if hour < startBookingTime{
            startTime = calendar.date(bySettingHour: startBookingTime, minute: 0, second: 0, of: startTime) ?? startTime
        }
        else if hour >= endBookingTime{
            startTime = calendar.date(bySettingHour: endBookingTime - 1, minute: 45, second: 0, of: startTime) ?? startTime
        }
    }
    
    func operationalEndHour(){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endTime)
        
        if hour < startBookingTime{
            endTime = calendar.date(bySettingHour: startBookingTime, minute: 0, second: 0, of: endTime) ?? endTime
        }
        else if hour > endBookingTime || (hour == endBookingTime && calendar.component(.minute, from: endTime) > 0){
            endTime = calendar.date(bySettingHour: endBookingTime, minute: 0, second: 0, of: endTime) ?? endTime
        }
    }
    
    func timeValidation(){
        if endTime <= startTime{
            endTime = Calendar.current.date(byAdding : .minute, value: 15, to: startTime) ?? startTime
        }
    }

    func statusFor(_ code: String) -> SlotStatus {
        floorMap.slots.first(where: { $0.id == code })?.status ?? .available
    }

    func isHandicap(_ code: String) -> Bool {
        floorMap.slots.first(where: { $0.id == code })?.isHandicap ?? false
    }

    func select(_ code: String) {
        guard statusFor(code) == .available || statusFor(code) == .priority else { return }
        selectedSlotID = (selectedSlotID == code) ? nil : code
    }

    var dateLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: selectedDate)
    }

    var timeRangeLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }

    var dayRangeLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: selectedDate)
    }

    var startTimeLabel: String {
        guard hasSetStartTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: startTime)
    }

    var endTimeLabel: String {
        guard hasSetEndTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: endTime)
    }
    

    // MARK: - Layout definition (grid columns, sama seperti denah asli)
    static func buildLayout() -> [SlotSection] {
        [
            SlotSection(columns: [
                .init(codes: ["D6","D5","D4","D3","D2","D1"]),
                .init(codes: ["C6","C5","C4","C3","C2","C1"]),
                .init(codes: ["B6","B5","B4","B3","B2","B1"]),
                .init(codes: ["A6","A5","A4","A3","A2","A1"])
            ]),
            SlotSection(columns: [
                .init(codes: ["I3","I2","I1","I4","I5","I6"]),
                .init(codes: ["H3","H2","H1","H4","H5","H6"]),
                .init(codes: ["G3","G2","G1","G4","G5","G6"]),
                .init(codes: ["F3","F2","F1","F4","F5"]),
                .init(codes: ["E2","E1","E3","E4","E5"])
            ]),
            SlotSection(columns: [
                .init(codes: ["N3","N2","N1","N4","N5","N6"]),
                .init(codes: ["M3","M2","M1","M4","M5","M6"]),
                .init(codes: ["L3","L2","L1","L4","L5","L6"]),
                .init(codes: ["K2","K1","K3","K4"]),
                .init(codes: ["J3","J2","J1","J4","J5","J6"])
            ])
        ]
    }

    static func mockFloorMap() -> FloorMap {
        let occupied: Set<String> = ["C4","B3","H2","F2","M2","L1","J2"]
        let priorityCodes = ["P1","P2","P3","P4"]

        var slots: [ParkingSlot] = []
        for section in buildLayout() {
            for col in section.columns {
                for code in col.codes {
                    slots.append(ParkingSlot(
                        id: code,
                        zone: "General",
                        status: occupied.contains(code) ? .occupied : .available
                    ))
                }
            }
        }
        for (i, code) in priorityCodes.enumerated() {
            slots.append(ParkingSlot(
                id: code,
                zone: "Priority",
                status: i == 1 ? .occupied : .priority,
                isHandicap: true
            ))
        }

        return FloorMap(mallId: "mall_1", floorId: "floor_1", backgroundImageURL: nil, slots: slots)
    }
}
