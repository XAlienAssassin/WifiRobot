import { Schema, model } from "mongoose";


export interface IOccupancyGrid {
    width: number;
    height: number;
    data: number[];
    resolution: number; //m per cell
}

export const occupancyGridSchema = new Schema<IOccupancyGrid>({
    width: { type: Number, required: true },
    height: { type: Number, required: true },
    data: { type: [ Number ] },
    resolution: { type: Number, required: true }
})

export const WifiSignal = model<IOccupancyGrid>('OccupancyGrid', occupancyGridSchema);