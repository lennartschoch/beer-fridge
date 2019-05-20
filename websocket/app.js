#!/usr/bin/env node

"use strict";

const WebSocket = require('ws');
const uuidv4 = require('uuid/v4');
const fs = require('fs');
const https = require('https');
const winston = require('winston');

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.cli(),
    transports: [
        new winston.transports.Console(),
    ]
});

require('dotenv').config()

const privateKey = fs.readFileSync('../ssl-cert/privkey.pem', 'utf8');
const certificate = fs.readFileSync('../ssl-cert/fullchain.pem', 'utf8');

const credentials = {key: privateKey, cert: certificate};

const httpsServer = https.createServer(credentials);
httpsServer.listen({port: 443, path: '/fridge'});

const wss = new WebSocket.Server({server: httpsServer});

const fridgeToken = process.env.FRIDGE_TOKEN;
const clientToken = process.env.CLIENT_TOKEN;

let clientConnections = [];
let fridgeConnection = null;

let currentState = {
    'state': null,
    'temperature': null
};

logger.log('info', 'Ready to drink some beer!');

wss.on('connection', function connection(ws, req) {

    if (req.headers['x-auth-token'] !== undefined) {

        if (req.headers['x-auth-token'] === fridgeToken) {

            handleFridgeConnection(ws);

        } else if (req.headers['x-auth-token'] === clientToken) {

            handleClientConnection(ws);

        } else {

            ws.close();
        }

    } else {

        ws.close();

    }

});

function handleFridgeConnection(ws) {

    logger.log('info', 'Connected to fridge.');

    if (fridgeConnection !== null) {
        fridgeConnection.close();
    }

    fridgeConnection = ws;

    ws.on('message', handleFridgeMessage);

    ws.on('close', () => {
        fridgeConnectionCloseHandler()
    });

}

function handleClientConnection(ws) {

    logger.log('info', 'Connected to client.');

    ws.id = uuidv4();
    clientConnections.push(ws);

    ws.on('message', handleClientMessage);
    ws.on('close', () => {
        clientConnectionCloseHandler(ws)
    });

    ws.send(JSON.stringify(currentState));

}

function handleFridgeMessage(message) {

    /**
     * Whenever the fridge sends a message, save it's current state to use it as a "welcome" message for new
     * connections and redirect it directly to all connected clients.
     */

    let jsonMessage = null;

    logger.log('info', `Received message from fridge: ${message}`);

    try {

        jsonMessage = JSON.parse(message);

    } catch (e) {
        logger.log('error', 'Unable to parse message from JSON.');
    }

    if (jsonMessage !== null) {

        // Check that only "state" and "temperature" keys are present
        const keyValidation = Object.keys(jsonMessage).filter(key => (key !== 'state' && key !== 'temperature')).length === 0;

        // if key "state" is valid, make sure it's either on or off
        const stateValidation =
            jsonMessage['state'] === undefined ||
            (
                jsonMessage['state'] !== undefined &&
                typeof jsonMessage['state'] === 'string' &&
                (jsonMessage['state'] === 'on' || jsonMessage['state'] === 'off')
            );

        // If key "temperature" is present, make sure it's a realistic number
        const temperatureValidation = jsonMessage['temperature'] === undefined ||
            (
                jsonMessage['temperature'] !== undefined &&
                typeof jsonMessage['temperature'] === 'number' &&
                jsonMessage['temperature'] > -10 && jsonMessage['temperature'] < 50
            );

        const emptyValidation = Object.keys(jsonMessage).length > 0;

        if (keyValidation && stateValidation && temperatureValidation && emptyValidation) {

            if (jsonMessage['state'] !== undefined) {
                currentState['state'] = jsonMessage['state'];
            }

            if (jsonMessage['temperature'] !== undefined) {
                currentState['temperature'] = jsonMessage['temperature'];
            }

            sendMessageToAllClients(message);

        } else {

            logger.log('error', 'Wrong format for fridge message.');

        }
    }

}


function handleClientMessage(message) {

    /**
     * Whenever a user sends a message, it's a request to change the state of the fridge.
     */

    let jsonMessage = null;

    logger.log('info', `Received message from client: ${message}`);

    try {

        jsonMessage = JSON.parse(message);

    } catch (e) {
        logger.log('error', 'Unable to parse message from JSON.');
    }

    if (jsonMessage !== null) {

        if (fridgeConnection === null) {

            logger.log('error', 'Not connected to fridge.');

        } else {

            if (Object.keys(jsonMessage).length > 1 || jsonMessage['state'] === undefined || (jsonMessage['state'] !== 'on' && jsonMessage['state'] !== 'off')) {

                logger.log('error', 'Wrong format for client message.');

            } else {

                fridgeConnection.send(message);

            }

        }

    }

}

function sendMessageToAllClients(message) {

    logger.log('info', 'Sending message from fridge to all clients.');

    clientConnections.forEach(function (ws) {
        ws.send(message);
    });

}

function clientConnectionCloseHandler(ws) {

    logger.log('info', 'Client connection closed.');

    /**
     *  When a client disconnects, remove the connection from the clientConnections array
     */

    clientConnections = clientConnections.filter(conn => conn.id !== ws.id);

}

function fridgeConnectionCloseHandler() {

    /**
     *  When the fridge disconnects, just set the connection to null, to not trigger any errors
     */

    logger.log('info', 'Disconnected from fridge.');

    fridgeConnection = null;

}