import { IOccupancyGrid } from "../models/OccupancyGrid";
import { IWifiCollection } from "../models/WifiCollection";
import { IWifiRun } from "../models/WifiRun";
import { IWifiSignal } from "../models/WifiSignal";
import { faker } from '@faker-js/faker';

export function CreateMockMap(mapSize: number): IOccupancyGrid {
    let occupancyGrid: IOccupancyGrid = {
        height: mapSize,
        width: mapSize,
        data: [],
        resolution: 0.5
    }

    for(let i = 0; i < mapSize; i++) {
        for(let j = 0; j < mapSize; j++) {
            occupancyGrid.data.push(Math.floor(Math.random() * (Math.round(Math.random()) == 1 ? -1 : 1) * 100));
        }
    }

    return occupancyGrid;
}

export function CreateMockWifiRun(): IWifiRun {
    let wifiRun: IWifiRun = { 
        isRunning: true,
        name: "Initial Run",
        scans: [],
        ranOn: new Date()
    };

    let scans: IWifiCollection[] = [];
    for(let i = 0; i < 10; i++) {
        let scan: IWifiCollection = {
            position: {
                x: 0, y: 0, z: 0
            },
            timestamp: new Date(),
            data: []
        };
        let data: IWifiSignal[] = [];
        for(let i = 0; i < 10; i++) {
            let signal: IWifiSignal = {
                address: faker.internet.ipv4(),
                essid: faker.address.city(),
                quality: faker.datatype.number(70),
                signalLevel: faker.datatype.number(70)
            };

            data.push(signal);
        }
        scan.data = data;
        scans.push(scan);
    }

    wifiRun.scans = scans;

    return wifiRun;
}