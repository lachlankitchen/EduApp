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
      std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "degrees.json";
      // Use std::filesystem::path to construct the path, which handles separators
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

  svr.Get("/:degree/majors", [&](const Request &req, Response &res)
          {
    auto degree = req.path_params.at("degree"); // TODO: @CONNOR Utilise when quering by degree
    std::cout << "Degree parameter: " << degree << std::endl;// PRINT statement for degrees here. need to develope functionality for each degree.
    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "degree_majors.json";

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
    res.set_content(json_content, "application/json ");

    std::cout << "Successfully served the JSON file.\n"; });

  svr.Get("/:degree/:major", [&](const Request &req, Response &res)
            {
    auto degree = req.path_params.at("degree"); // TODO: @CONNOR Utilise when quering by degree
    auto major = req.path_params.at("major"); // TODO: @CONNOR Utilise when quering by major
    std::cout << "Degree parameter: " << degree << std::endl;
    std::cout << "Major parameter: " << major << std::endl;
    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "major_requirements.json";

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

  svr.Post("/:degree/:major", [&](const Request &req, Response &res)
            {
    std::cout << "POST request received.\n";

    auto degree = req.path_params.at("degree"); // TODO: @CONNOR Utilise when quering by major
    auto major = req.path_params.at("major"); // TODO: @CONNOR Utilise when quering by major

    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "paper_response.json";

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