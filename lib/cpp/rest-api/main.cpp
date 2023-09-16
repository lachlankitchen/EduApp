#include "httplib.h"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>

int main(void)
{
  using namespace httplib;

  Server svr;

  svr.Get("/degrees", [](const Request &req, Response &res)
          {
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

       std::cout << "Successfully served the JSON file.\n"; });

  // Capture the second segment of the request path as "id" path param
  svr.Get("/majors/:degree", [&](const Request &req, Response &res)
          {
    auto degree = req.path_params.at("degree");
    res.set_content(degree, "text/plain"); });

  svr.Get("/majors", [](const Request &req, Response &res)
          {
       std::filesystem::path json_file_path = "../../../data/major_requirements.json"; // Specify the correct path to your JSON file
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

       std::cout << "Successfully served the JSON file.\n"; });

  // svr.Get("/paper/{paperCode}", [](const Request &req, Response &res){
  //   // TODO: @CONNOR Implement this
  // });


  // svr.Get("/userPaperList", [](const Request &req, Response &res){
  //   // TODO: @CONNOR Implement this
  // });

  // Extract values from HTTP headers and URL query params
  svr.Get("/body-header-param", [](const Request &req, Response &res)
          {
    if (req.has_header("Content-Length")) {
      auto val = req.get_header_value("Content-Length");
    }
    if (req.has_param("key")) {
      auto val = req.get_param_value("key");
    }
    res.set_content(req.body, "text/plain"); });

  svr.Get("/stop", [&](const Request &req, Response &res)
          { svr.stop(); });

  svr.listen("localhost", 1234);
}