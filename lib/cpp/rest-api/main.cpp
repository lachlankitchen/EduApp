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

int rest_api(void) {
    using namespace httplib;

    Server svr;

    // Define hardcoded file paths
    std::filesystem::path single_degrees_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/singleDegreesWithMajors.json";
    std::filesystem::path majors_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/majors.json";
    std::filesystem::path major_requirements_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/major_requirements.json";
    std::filesystem::path paper_response_json_path = "C:/Users/AHopgood/Documents/Repo/EduApp/lib/data/paper_response.json";

    svr.Get("/degrees", [single_degrees_json_path](const Request &req, Response &res) {
        std::filesystem::path json_file_path = single_degrees_json_path;

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

    svr.Get("/:degree/majors", [majors_json_path](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");
        std::filesystem::path json_file_path = majors_json_path;

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

    svr.Get("/:degree/:major/papers/:levelInt", [paper_response_json_path](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");
        auto levelInt = req.path_params.at("level");
        std::string level = levelInt + "-level";
        std::filesystem::path json_file_path = paper_response_json_path;

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

    svr.Get("/:degree/:major/:papers", [major_requirements_json_path](const Request &req, Response &res) {
        auto degree = req.path_params.at("degree");
        auto major = req.path_params.at("major");
        auto papers_string = req.path_params.at("papers");

        std::cout << papers_string << std::endl;
        std::vector<std::string> papers;
        std::stringstream ss(papers_string);
        std::string paper;
        while (std::getline(ss, paper, ',')) {
            papers.push_back(paper);
        }

        std::filesystem::path json_file_path = major_requirements_json_path;

        if (!std::filesystem::exists(json_file_path)) {
            res.status = 404;
            res.set_content("File not found", "text/plain");
            std::cout << "File not found at specified path.\n";
            return;
        }

        std::ifstream json_file(json_file_path);
        nlohmann::json json_obj;
        json_file >> json_obj;

        std::string jsonString = json_obj.dump();

        if (!jsonString.empty()) {
            std::string aggregateFeedback = "";
            bool allRequirementsMet = true;

            std::string jsonMajor = json_obj[major].dump();
            if (!jsonMajor.empty()) {
                DegreeRequirements degreeReqs(jsonMajor);

                std::pair<bool, std::string> result = degreeReqs.checkRequirements(papers);

                if (!result.first) {
                    allRequirementsMet = false;
                }
                aggregateFeedback += major + ": " + result.second + "\n";
                std::cout << aggregateFeedback << std::endl;

            } else {
                aggregateFeedback += major + ": Major data not found in the JSON.\n";
                allRequirementsMet = false;
            }

            if (allRequirementsMet) {
                res.status = 200;
                res.set_content("All requirements met for the majors!", "text/plain");
            } else {
                res.status = 400;
                res.set_content(aggregateFeedback, "text/plain");
            }
        } else {
            res.status = 404;
            res.set_content("Major requirements data not found", "text/plain");
        }

        setCorsHeaders(res);
    });

    svr.Get("/papers/:query/:level", [paper_response_json_path](const Request &req, Response &res) {
        auto query = req.path_params.at("query");
        auto levelStr = req.path_params.at("level");

        std::transform(query.begin(), query.end(), query.begin(), ::toupper);

        std::filesystem::path json_file_path = paper_response_json_path;

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

int main() {
    rest_api();
    return 0;
}