// DegreeRequirements.h

#ifndef DEGREE_REQUIREMENTS_H
#define DEGREE_REQUIREMENTS_H

#include <nlohmann/json.hpp>
#include <string>
#include <unordered_set>
#include <vector>

class DegreeRequirements
{
private:
    nlohmann::json degreeData;

public:
    // Constructor
    DegreeRequirements(const std::string &jsonData);

    // Public member function
    bool checkRequirements(const std::vector<std::string> &completedPapers);
};

#endif // DEGREE_REQUIREMENTS_H
