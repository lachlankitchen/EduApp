#include "httplib.h"

int main(void)
{
  using namespace httplib;

  Server svr;

  svr.Get("/hi", [](const Request& req, Response& res) {
    res.set_content("Hello World!", "text/plain");
  });

  // Match the request path against a regular expression
  // and extract its captures
  svr.Get(R"(/numbers/(\d+))", [&](const Request& req, Response& res) {
    auto numbers = req.matches[1];
    res.set_content(numbers, "text/plain");
  });

  // Capture the second segment of the request path as "id" path param
  svr.Get("/users/:id", [&](const Request& req, Response& res) {
    auto user_id = req.path_params.at("id");
    res.set_content(user_id, "text/plain");
  });

  // Extract values from HTTP headers and URL query params
  svr.Get("/body-header-param", [](const Request& req, Response& res) {
    if (req.has_header("Content-Length")) {
      auto val = req.get_header_value("Content-Length");
    }
    if (req.has_param("key")) {
      auto val = req.get_param_value("key");
    }
    res.set_content(req.body, "text/plain");
  });

  svr.Get("/stop", [&](const Request& req, Response& res) {
    svr.stop();
  });

  svr.listen("localhost", 1234);
}

// #include "httplib.h"
// #include <nlohmann/json.hpp> // Include the JSON library

// using json = nlohmann::json; // Alias for JSON

// int main(void) {
//     using namespace httplib;

//     Server svr;

//     svr.Get("/hi", [](const Request& req, Response& res) {
//         json response_json = {{"message", "Hello World!"}}; // Create a JSON object
//         res.set_content(response_json.dump(), "application/json"); // Set content type to JSON
//     });

//     // Match the request path against a regular expression
//     // and extract its captures
//     svr.Get(R"(/numbers/(\d+))", [&](const Request& req, Response& res) {
//         auto numbers = req.matches[1];
//         json response_json = {{"number", numbers}}; // Create a JSON object
//         res.set_content(response_json.dump(), "application/json"); // Set content type to JSON
//     });

//     // Capture the second segment of the request path as "id" path param
//     svr.Get("/users/:id", [&](const Request& req, Response& res) {
//         auto user_id = req.path_params.at("id");
//         json response_json = {{"user_id", user_id}}; // Create a JSON object
//         res.set_content(response_json.dump(), "application/json"); // Set content type to JSON
//     });

//     // Extract values from HTTP headers and URL query params
//     svr.Get("/body-header-param", [](const Request& req, Response& res) {
//         if (req.has_header("Content-Length")) {
//             auto val = req.get_header_value("Content-Length");
//         }
//         if (req.has_param("key")) {
//             auto val = req.get_param_value("key");
//         }
//         json response_json = {{"body", req.body}}; // Create a JSON object
//         res.set_content(response_json.dump(), "application/json"); // Set content type to JSON
//     });

//     svr.Get("/stop", [&](const Request& req, Response& res) {
//         svr.stop();
//     });

//     svr.listen("localhost", 1234);
// }
