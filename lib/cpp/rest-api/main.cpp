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


  svr.Get("/:degree/:major/papers/:level", [&](const Request &req, Response &res) {
    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "responseData.json";

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

  svr.Get("/papers/:query/:level", [&](const Request &req, Response &res) {
    std::cout << "HIT\n";

    auto query = req.path_params.at("query");
    auto levelStr = req.path_params.at("level");

    std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "papers_data.json";

    if (!std::filesystem::exists(json_file_path)) {
        res.status = 404;
        res.set_content("File not found", "text/plain");
        std::cout << "File not found at specified path.\n";
        return;
    }

    // Parse the level from the request as an integer
    int level = std::stoi(levelStr);

    // Create a JSON object to store matching papers
    nlohmann::json matching_papers;

    // Read the JSON file into a nlohmann::json object
    std::ifstream json_file(json_file_path);
    nlohmann::json json_obj;
    json_file >> json_obj;

    // Iterate through the papers in the JSON object
    for (const auto &paper : json_obj.items()) {
        // Extract the last three characters from the paper key as the paper's level
        std::string paperKey = paper.key();
        std::string paperLevelStr = paperKey.substr(paperKey.size() - 3);

        // Parse the paper's level as an integer
        int paperLevel = std::stoi(paperLevelStr);

        // Check if the paper key contains the query and the paper's level is within the specified range
        if (paperKey.find(query) != std::string::npos && paperLevel >= level && paperLevel < level + 100) {
            // Add the matching paper to the result JSON
            matching_papers[paperKey] = paper.value();
        }
    }

    // Check if any matching papers were found
    if (!matching_papers.empty()) {
        // Set the response with the array of matching papers
        res.set_content(matching_papers.dump(), "application/json");
    } else {
        // If no matching papers are found, return a 404 error
        res.status = 404;
        res.set_content("No matching papers found", "text/plain");
    }

    res.set_header("Access-Control-Allow-Origin", "*");
    res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
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