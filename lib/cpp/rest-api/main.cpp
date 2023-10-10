#include "httplib.h"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>
#include "../DegreeRequirements.h"

using namespace std;

void setCorsHeaders(httplib::Response &res) {
    res.set_header("Access-Control-Allow-Origin", "*");
    res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
}

int rest_api(void)
{
    using namespace httplib;

    Server svr;

    svr.Get("/degrees", [](const Request &req, Response &res) {
        std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "singleDegreesWithMajors.json";
        
        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(json_file_path);
        std::string json_content((std::istreambuf_iterator<char>(json_file)), std::istreambuf_iterator<char>());
        
        res.set_content(json_content, "application/json");
        setCorsHeaders(res);
    });

    svr.Get("/:degree/majors", [&](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");
        std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "majors.json";

        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(json_file_path);
        nlohmann::json json_obj;
        json_file >> json_obj;

        if (json_obj.contains(degree)) {
            res.set_content(json_obj[degree].dump(), "application/json");
        } else {
            res.status = 404;
            res.set_content("Degree not found", "text/plain");
        }
           
        setCorsHeaders(res);
    });

    svr.Get("/:degree/:major/papers/:level", [&](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");
        auto levelInt = req.path_params.at("level");
        std::string level = levelInt + "-level";
        std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "output_file.json";

        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(json_file_path);
        nlohmann::json json_obj;
        json_file >> json_obj;
        res.set_content(json_obj[degree][major][level].dump(), "application/json");
        setCorsHeaders(res);
    });

    svr.Post("/:degree/:major", [&](const Request &req, Response &res) {
        std::cout << "POST request w/ body received" << std::endl;

        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");
        std::string papers_string = req.body;

        try {
            auto json_papers = nlohmann::json::parse(papers_string);
            std::cout << json_papers << std::endl;
        } catch (const nlohmann::json::exception& e) {
            std::cerr << "JSON parsing error: " << e.what() << std::endl;
            std::cerr << "Failed string: " << papers_string << std::endl;
        }
    });

    svr.Post("/:degree/:major/:papers", [&](const Request &req, Response &res) {
        std::cout << "POST request received" << std::endl;

        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");
        auto papers_string = req.path_params.at("papers");
        
        // Parse the JSON string directly
        nlohmann::json json_papers;
        try {
            json_papers = nlohmann::json::parse(papers_string);
            std::cout << json_papers << std::endl;
        } catch (const nlohmann::json::exception& e) {
            std::cerr << "JSON parsing error: " << e.what() << std::endl;
            std::cerr << "Failed string: " << papers_string << std::endl;
        }



        std::cout << json_papers << std::endl;

        // Convert the parsed JSON array to a vector of strings
        std::vector<std::string> papers;
        for (const auto& paper : json_papers) {
            std::cout << paper << std::endl;
            papers.push_back(paper.dump());
        }

        std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "majorRequirements.json";

        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(json_file_path);
        nlohmann::json json_obj;
        json_file >> json_obj;
        // Convert the JSON object to its string representation
        std::string jsonString = json_obj.dump(); 

        if (!jsonString.empty()) {
            std::string aggregateFeedback;
            bool allRequirementsMet = true;

            std::string jsonMajor = json_obj[major].dump(); 
            if (!jsonMajor.empty()) {
                DegreeRequirements degreeReqs(jsonMajor);
            
                nlohmann::json result = degreeReqs.checkRequirements(papers);

                // Check if result is empty
                if (!result.empty()) {
                    allRequirementsMet = false;
                }

                aggregateFeedback = result[0].dump();
            } else {
                res.status = 400;
                res.set_content("Could find find selected major", "text/plain");
            }

            if (allRequirementsMet) {
                res.status = 200;
                res.set_content("All requirements met for the majors!", "text/plain");
            } else {
                res.status = 200;
                res.set_content(aggregateFeedback, "text/plain");
            }
        } else {
            res.status = 404;
            res.set_content("Major requirements data not found", "text/plain");
        }

        setCorsHeaders(res);
    });


    svr.Get("/papers/:query/:level", [&](const Request &req, Response &res) {
        auto query = req.path_params.at("query");
        auto levelStr = req.path_params.at("level");

        std::transform(query.begin(), query.end(), query.begin(), ::toupper);

        std::filesystem::path json_file_path = std::filesystem::path("..") / ".." / ".." / "data" / "papers_data.json";

        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        int level = std::stoi(levelStr);
        nlohmann::json matching_papers;

        std::ifstream json_file(json_file_path);
        nlohmann::json json_obj;
        json_file >> json_obj;

        for (const auto &paper : json_obj.items()) {
            std::string paperKey = paper.key();
            std::string paperLevelStr = paperKey.substr(paperKey.size() - 3);
            int paperLevel = std::stoi(paperLevelStr);

            if (paperKey.find(query) != std::string::npos && paperLevel >= level && paperLevel < level + 100) {
                matching_papers[paperKey] = paper.value();
            }
        }

        if (!matching_papers.empty()) {
            res.set_content(matching_papers.dump(), "application/json");
        } else {
            res.status = 404;
            res.set_content("No matching papers found", "text/plain");
        }

        setCorsHeaders(res);
    });

    svr.Post("/body-header-param", [](const Request &req, Response &res) {
        std::cout << req.body;

        res.set_content(req.body, "text/plain");
        setCorsHeaders(res);
    });

    svr.Get("/stop", [&](const Request &req, Response &res) {
        svr.stop();
    });

    svr.listen("localhost", 1234);

    return 0;
}

int main(){
    rest_api();
  
    return 0;
}