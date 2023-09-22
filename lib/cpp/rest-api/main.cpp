//  cmake -DCMAKE_TOOLCHAIN_FILE=C:/Users/AHopgood/dev/vcpkg/scripts/buildsystems/vcpkg.cmake ..
//  msbuild rest_api.vcxproj

#include "httplib.h"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>

int main(void) {
    using namespace httplib;

    Server svr;

    // Define hardcoded file paths
    std::filesystem::path single_degrees_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/singleDegreesWithMajors.json";
    std::filesystem::path majors_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/majors.json";
    std::filesystem::path major_requirements_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/major_requirements.json";
    std::filesystem::path paper_response_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/paper_response.json";

    svr.Get("/degrees", [single_degrees_json_path](const Request &req, Response &res) {
        if (!std::filesystem::exists(single_degrees_json_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(single_degrees_json_path);
        std::string json_content((std::istreambuf_iterator<char>(json_file)),
            std::istreambuf_iterator<char>());

        res.set_header("Access-Control-Allow-Origin", "*");
        res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
        res.set_content(json_content, "application/json");
    });

    svr.Get("/:degree/majors", [majors_json_path](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");

        if (!std::filesystem::exists(majors_json_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(majors_json_path);
        nlohmann::json json_obj;
        json_file >> json_obj;

        if (json_obj.contains(degree)) {
            res.set_content(json_obj[degree].dump(), "application/json");
        } else {
            res.status = 404;
            res.set_content("Degree not found", "text/plain");
        }

        res.set_header("Access-Control-Allow-Origin", "*");
        res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
    });

    svr.Get("/:degree/:major", [major_requirements_json_path](const Request &req, Response &res) {
        auto major = req.path_params.at("major");

        if (!std::filesystem::exists(major_requirements_json_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(major_requirements_json_path);
        std::string json_content((std::istreambuf_iterator<char>(json_file)),
            std::istreambuf_iterator<char>());

        res.set_header("Access-Control-Allow-Origin", "*");
        res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
        res.set_content(json_content, "application/json");

        std::cout << "Successfully served the JSON file.\n";
    });

    svr.Post("/:degree/:major", [paper_response_json_path](const Request &req, Response &res) {
        std::cout << "POST request received.\n";

        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");

        if (!std::filesystem::exists(paper_response_json_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(paper_response_json_path);
        std::string json_content((std::istreambuf_iterator<char>(json_file)),
            std::istreambuf_iterator<char>());

        res.set_header("Access-Control-Allow-Origin", "*");
        res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
        res.set_content(json_content, "application/json");

        std::cout << "Successfully served the JSON file.\n";
    });

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
