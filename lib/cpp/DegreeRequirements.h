// DegreeRequirements.h

#ifndef DEGREE_REQUIREMENTS_H
#define DEGREE_REQUIREMENTS_H

#include <nlohmann/json.hpp>
#include <string>
#include <unordered_set>
#include <vector>

using namespace std;

class DegreeRequirements
{
private:
    nlohmann::json majorData;

public:
    // Constructor
    DegreeRequirements(const std::string &jsonData);

    // Public member function
    std::pair<bool, std::string> checkRequirements(const std::vector<std::string> &completedPapers);

    std::string checkSingleMajor(const nlohmann::json &majorData, const std::unordered_set<std::string> &completedSet);
};

#endif // DEGREE_REQUIREMENTS_H
