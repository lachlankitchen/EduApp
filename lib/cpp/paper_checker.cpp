#include <nlohmann/json.hpp>
#include "paper_checker.h"
#include <iostream>
#include <unordered_set>

using json = nlohmann::json;
using namespace std;

DegreeRequirements::DegreeRequirements(const string& jsonData) {
    degreeData = json::parse(jsonData);
}

bool DegreeRequirements::checkRequirements(const vector<string>& completedPapers) {
    unordered_set<string> completedSet(completedPapers.begin(), completedPapers.end());

    for (const auto& level : degreeData["levels"]) {
        // Check compulsory papers
        if (level.contains("compulsory_papers")) {
            for (const auto& paper : level["compulsory_papers"]) {
                if (completedSet.find(paper) == completedSet.end()) {
                    cout << "Missing compulsory paper: " << paper << endl;
                    return false;
                }
            }
        }

        // Check one_of_papers
        if (level.contains("one_of_papers")) {
            bool oneOfPassed = false;
            for (const auto& paper : level["one_of_papers"]) {
                if (completedSet.find(paper) != completedSet.end()) {
                    oneOfPassed = true;
                    break;
                }
            }
            if (!oneOfPassed) {
                cout << "Must complete at least one of the papers in the list for " << level["level"] << endl;
                return false;
            }
        }
    }

    // Check total points (assuming each paper is worth a certain number of points)
    int totalPoints = completedPapers.size() * 18; // Assuming each paper is 18 points
    if (totalPoints < degreeData["total"]) {
        cout << "Total points not met. Required: " << degreeData["total"] << ", Achieved: " << totalPoints << endl;
        return false;
    }

    return true;
}

int main() {
    string jsonData = R"({
        // ... [Your JSON data here] ...
    })";

    DegreeRequirements dr(jsonData);
    vector<string> completedPapers = {
        "COMP 101", "COMP 161", "COMP 162", "MATH 120", "COSC 201", "COSC 202", "COSC 203", "COSC 204", "COSC 326"
        // ... [Add more completed papers as needed] ...
    };

    if (dr.checkRequirements(completedPapers)) {
        cout << "Degree requirements satisfied!" << endl;
    } else {
        cout << "Degree requirements not satisfied." << endl;
    }

    return 0;
}
