#!/bin/bash

# Function to start services
start_services() {
    # Start the REST API
    cd lib/cpp/rest-api/build
    ./rest_api &
    echo $! > ../../../../rest_api.pid

    # Start the Flutter app
    cd ../../../../
    flutter run -d chrome &
    echo $! > flutter_app.pid

    echo "Services started."
}

# Function to stop services
stop_services() {
    if [ -f rest_api.pid ] && [ -f flutter_app.pid ]; then
        kill $(cat rest_api.pid) && rm rest_api.pid
        kill $(cat flutter_app.pid) && rm flutter_app.pid
        echo "Services stopped."
    else
        echo "No PID files found. Cannot stop services."
    fi
}

# Check the first argument to the script
if [ "$1" == "start" ]; then
    start_services
elif [ "$1" == "stop" ]; then
    stop_services
else
    echo "Usage: $0 {start|stop}"
fi
