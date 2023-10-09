#pragma once

#include <string>
#include <vector>
#include <unordered_set>
#include <nlohmann/json.hpp>

class DegreeRequirements 
{
public:
    // Constructor
    DegreeRequirements(const std::string &jsonData);

    /**
     * Check the degree requirements for the completed papers.
     * @param completedPapers A vector containing the names of completed papers.
     * @return A JSON object detailing unmet requirements for each major.
     */
    nlohmann::json checkRequirements(const std::vector<std::string> &completedPapers);

private:
    /**
     * Check the degree requirements for a single major.
     * @param majorData A JSON object containing the major's requirements.
     * @param completedSet A set containing the names of completed papers.
     * @return A JSON object detailing the unmet requirements for the major.
     */
    nlohmann::json checkSingleMajor(const nlohmann::json &majorData, const std::unordered_set<std::string> &completedSet);

    std::string intToWord(int num);

    // Member variables (assuming a member for storing the degree data)
    nlohmann::json degreeData;
};
