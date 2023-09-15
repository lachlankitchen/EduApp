#include "httplib.h"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>


int main(void)
{
  using namespace httplib;

  Server svr;


   svr.Get("/degrees", [](const Request& req, Response& res) {
       std::filesystem::path json_file_path = "../../../data/degrees.json"; // Specify the correct path to your JSON file
       if (!std::filesystem::exists(json_file_path)) {
           res.status = 404;
           res.set_content("File not found", "text/plain");
           std::cout << "File not found at specified path.\n";
           return;
       }

       std::ifstream json_file(json_file_path);
       std::string json_content((std::istreambuf_iterator<char>(json_file)),
                                std::istreambuf_iterator<char>());

       res.set_header("Access-Control-Allow-Origin", "*");
       res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
       res.set_content(json_content, "application/json");

       std::cout << "Successfully served the JSON file.\n";
   });






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
