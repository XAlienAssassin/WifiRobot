import { RemoteInfo } from "dgram";
import { ITcpSocket, TCPServer } from "../servers/TCPServer";
import net from 'net'

type Client = {
    socket: net.Socket;
    wait: boolean;
}  

abstract class NetworkDelegate implements ITcpSocket {
    port: number;
    clients: Client[] = []
    server: TCPServer;


    constructor(port: number) {
        this.port = port;
        this.server = new TCPServer(this);
    }

    abstract onMessage(msg: Buffer, rinfo: RemoteInfo): void;
    
    publish(data: object) {
        var stringified = JSON.stringify(data);
        for(var client of this.clients.filter(c => !this.server.senders.has(c.socket))) {
            if(true) {
                let val= client.socket.write(stringified, (err) => {
                    if(err) {
                        console.log("Error publishing data")
                    } else {
                        client.socket.write("end")
                    }
                });
                //console.log(val)
                // client.wait = !val;
            }
        }
    }

    onDrain(client: net.Socket) {
        // this.clients = this.clients.map(e => { 
        //     if(e.socket == client) {
        //         return { socket: client, wait: false }
        //     } else {
        //         return e;
        //     }
        // });
    }

    onConnect(socket: net.Socket): void {
        this.clients.push({ socket: socket, wait: false });
    }

    onClose(client: net.Socket) {
        this.clients = this.clients.filter(c => c.socket !== client);
    }

    onError(client: net.Socket) {
        this.clients = this.clients.filter(c => c.socket !== client);
    }

    listen() {
        console.log(`Server listening: ${process.env.HOST_ADDRESS}`)
        this.server.listen();
    }
}

export default NetworkDelegate