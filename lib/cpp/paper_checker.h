// lib/cpp/paper_checker.h
#ifndef PAPER_CHECKER_H
#define PAPER_CHECKER_H

#include <string>
#include <vector>
#include <nlohmann/json.hpp>

class DegreeRequirements {
public:
    DegreeRequirements(const std::string& jsonData);
    bool checkRequirements(const std::vector<std::string>& completedPapers);
private:
    nlohmann::json degreeData;
};

#endif // PAPER_CHECKER_H
