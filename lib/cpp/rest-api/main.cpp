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
      std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "singleDegreesWithMajors.json";
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

       });// get degrees.

  svr.Get("/:degree/majors", [&](const Request &req, Response &res)
  {
      auto degree = req.path_params.at("degree");
      std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "majors.json";

      if (!std::filesystem::exists(json_file_path)) {
          res.status = 404;
          res.set_content("File not found", "text/plain");
          std::cout << "File not found at specified path.\n";
          return;
      }

      // Read the JSON file into a nlohmann::json object
      std::ifstream json_file(json_file_path);
      nlohmann::json json_obj;
      json_file >> json_obj;

      // Find the JSON object that matches the degree specified in the URL
      if (json_obj.contains(degree)) {
          // Set the response with the array of majors for the specified degree
          res.set_content(json_obj[degree].dump(), "application/json");
      } else {
          // If the degree is not found in the JSON file, return a 404 error
          res.status = 404;
          res.set_content("Degree not found", "text/plain");
      }

      res.set_header("Access-Control-Allow-Origin", "*");
      res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
  });


  svr.Get("/:degree/:major", [&](const Request &req, Response &res)
            {
    auto major = req.path_params.at("major"); // TODO: @CONNOR Utilise when quering by major

    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "paper_recommendations.json";

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

    std::cout << "Successfully served the JSON file.\n"; }); //get major requirements by degree and major.

  svr.Post("/:degree/:major", [&](const Request &req, Response &res)
            {
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

  svr.Get("/:degree/papers/:level", [](const Request &req, Response &res){
    // TODO: @CONNOR Implement this
    std::cout << "POST request received.\n";

    auto degree = req.path_params.at("degree"); // TODO: @CONNOR Utilise when quering by major
    auto level = req.path_params.at("level"); // TODO: @CONNOR Utilise when quering by major

    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "elective_papers.json";

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