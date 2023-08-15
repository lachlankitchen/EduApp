#define CROW_MAIN // Define this before including Crow header.
#include "crow_all.h"

int main()
{
    crow::SimpleApp app;

    // A simple endpoint that returns a greeting message.
    CROW_ROUTE(app, "/greeting")
    ([]()
     { return "Hello from the C++ backend!"; });

    // An endpoint that returns a simple JSON object.
    CROW_ROUTE(app, "/data")
    ([]()
     {
        crow::json::wvalue x;
        x["message"] = "Here's some data from the backend.";
        x["number"] = 42;
        return x; });

    app.port(4000).run(); // Run the server on port 4000.
}
