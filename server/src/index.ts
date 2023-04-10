import express from 'express';
import mongoose from 'mongoose';
import { WifiRun } from './models/WifiRun';
import { TCPServer } from './servers/TCPServer';
import TcpMapDelegate from './TcpDelegates/TcpMapDelegate';
import TcpWifiDelegate from './TcpDelegates/TcpWifiDelegate';
import * as dotenv from 'dotenv'
import { CreateMockWifiRun } from './utils/mock';
dotenv.config()

const db_url = 'mongodb://localhost:27017';
const db_name = 'bot_db'

const socketServer = new TcpMapDelegate();
const wifiServer = new TcpWifiDelegate();

async function connectDb() {
	await mongoose.connect(`${db_url}/${db_name}`);
	mongoose.connection.db.dropDatabase();
	console.log("Connected sucessfully to Mongodb");
}

const app = express();

app.get('/', (req, res) => {
	res.send('Hello World!');
});

//GET: The Turtlebot's most recent wifi poll
app.get('/api/wifi/:runId/latest', async (req, res) => {
	let latestRun = await WifiRun.findOne({ _id: req.params.runId });
	res.send("on prog.");
})

app.get(`/api/wifi/:runId`, async (req, res) => {
	res.send(await WifiRun.find({ _id: req.params.runId }));
})

app.get(`/api/runs`, async(req, res) => {
	res.send(await WifiRun.find().sort({ ranOn: -1 }).select({ name: 1, _id: 1 }))
})

app.listen(3000, async () => {
	// await connectDb();

	if(process.env.USE_MOCK == "true") {
		//await upsertMockData();
	}
	socketServer.listen();
	wifiServer.listen();
	console.log('The application is listening on port 3000');
});

async function upsertMockData() {
	//Create a mock run
	let wifiRun = CreateMockWifiRun();
	const run = new WifiRun(wifiRun);
	await run.save()
}