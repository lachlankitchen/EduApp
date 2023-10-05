#include <nlohmann/json.hpp>
#include <unordered_set>
#include <vector>
#include <string>
#include <sstream>
#include <iostream>

class DegreeRequirements
{
private:
    nlohmann::json degreeData;

public:
    // Constructor
    DegreeRequirements(const std::string &jsonData);
    
    // Public member function
    std::pair<bool, std::string> checkRequirements(const std::vector<std::string> &completedPapers);

    // Helper function to process a single major's requirements
    std::string checkSingleMajor(const nlohmann::json &majorData, const std::unordered_set<std::string> &completedSet);
};

DegreeRequirements::DegreeRequirements(const std::string &jsonData)
{
    degreeData = nlohmann::json::parse(jsonData);
}

std::pair<bool, std::string> DegreeRequirements::checkRequirements(const std::vector<std::string> &completedPapers) 
{
    std::unordered_set<std::string> completedSet(completedPapers.begin(), completedPapers.end());
    std::string feedback = "";

    std::cout << degreeData.dump() << std::endl;
    feedback += checkSingleMajor(degreeData, completedSet) + "\n";

    // for (const auto &majorEntry : degreeData["majors"].items()) 
    // {
    //     feedback += majorEntry.key() + ": ";
    //     std::cout << "Checking requirements for major: " << majorEntry.value() << std::endl;
    //     feedback += checkSingleMajor(majorEntry.value(), completedSet) + "\n";
    // }

    if (feedback.empty()) 
    {
        return {true, "All requirements met for all majors!"};
    } 
    else 
    {
        return {false, feedback};
    }
}

std::string DegreeRequirements::checkSingleMajor(const nlohmann::json &majorData, const std::unordered_set<std::string> &completedSet) 
{
    std::string feedback = "";
    
    // Your existing logic for checking a single major goes here
    if (majorData.contains("levels")) 
    {
        std::cout << majorData["levels"] << std::endl;

        for (const auto &levelEntry : majorData["levels"].items()) 
        {
            const std::string &levelName = levelEntry.key();
            const nlohmann::json &levelData = levelEntry.value();

            // Check compulsory papers
            if (levelData.contains("compulsory_papers")) 
            {
                for (const auto &paper : levelData["compulsory_papers"]) 
                {
                    if (completedSet.find(paper) == completedSet.end()) 
                    {
                        feedback += "Missing compulsory paper: " + std::string(paper) + ". ";
                    }
                }
            }

            // Check 'one_of_papers' through 'six_of_papers'
            for (int i = 1; i <= 6; i++) 
            {
                std::string paperRequirement = std::to_string(i) + "_of_papers";
                if (levelData.contains(paperRequirement)) 
                {
                    int countPassed = 0;
                    for (const auto &paper : levelData[paperRequirement]) 
                    {
                        if (completedSet.find(paper) != completedSet.end()) 
                        {
                            countPassed++;
                        }
                    }
                    if (countPassed < i) 
                    {
                        feedback += "Must complete at least " + std::to_string(i) + " of the papers in the list for " + levelName + ". ";
                    }
                }
            }
        }
    }

    // Check remaining points and points_at_<level>
    if (majorData.contains("remaining_points")) 
    {
        int remainingPoints = majorData["remaining_points"];
        int pointsAtLevel = majorData["points_at_200-level"];
        int totalPoints = completedSet.size() * 18; // Assuming each paper is 18 points

        if (totalPoints < remainingPoints) 
        {
            feedback += "Total points not met. Required: " + std::to_string(remainingPoints) + ", Achieved: " + std::to_string(totalPoints) + ". ";
        }
        if (totalPoints < pointsAtLevel) 
        {
            feedback += "Total points not met at 200-level. Required: " + std::to_string(pointsAtLevel) + ", Achieved: " + std::to_string(totalPoints) + ". ";
        }
    }

    return feedback;
}
