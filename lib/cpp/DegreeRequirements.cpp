#include <nlohmann/json.hpp>
#include <unordered_set>
#include <vector>
#include <string>
#include <sstream>
#include <iostream>
#include "DegreeRequirements.h"

DegreeRequirements::DegreeRequirements(const std::string &jsonData)
{
    degreeData = nlohmann::json::parse(jsonData);
}

nlohmann::json DegreeRequirements::checkRequirements(const std::vector<std::string> &completedPapers) 
{
    std::unordered_set<std::string> size(completedPapers.begin(), completedPapers.end());

    std::unordered_set<std::string> completedSet(completedPapers.begin(), completedPapers.end());
    nlohmann::json feedback;

    std::cout << degreeData.dump() << std::endl;
    feedback += checkSingleMajor(degreeData, completedSet);

    // for (const auto &majorEntry : degreeData["majors"].items()) 
    // {
    //     nlohmann::json majorFeedback = checkSingleMajor(majorEntry.value(), completedSet);
    //     if (!majorFeedback.empty())
    //         feedback[majorEntry.key()] = majorFeedback;
    // }

    return feedback;
}

nlohmann::json DegreeRequirements::checkSingleMajor(const nlohmann::json &majorData, const std::unordered_set<std::string> &completedSet) 
{
    nlohmann::json feedback;

    // std::cout << majorData << std::endl;

    std::cout << majorData["levels"] << std::endl;

    int completedElectivePoints = completedSet.size() * 18; // Start with all points being elective
    int completedCompulsoryPoints = 0; // Start with all points being elective
    int completedNOfPoints = 0; // Start with all points being elective

    if (majorData.contains("levels")) 
    {
        for (const auto &levelEntry : majorData["levels"].items()) 
        {
            const nlohmann::json &levelData = levelEntry.value();

            // Deduct points for compulsory papers that are completed
            if (levelData.contains("compulsory_papers")) 
            {
                for (const auto &paper : levelData["compulsory_papers"]) 
                {
                    if (completedSet.find(paper) != completedSet.end()) 
                    {
                        completedCompulsoryPoints += 18;
                    }
                    else
                    {
                        feedback["remaining_compulsory_papers"].push_back(paper);
                    }
                }
            }

            // Deduct points for 'one_of_papers' through 'six_of_papers' that are completed
            for (int i = 1; i <= 6; i++) 
            {
                std::string paperRequirement = intToWord(i) + "_of_papers";
                int missingNOfPapers = i;

                if (levelData.contains(paperRequirement)) 
                {
                    // for each paper in n_of_papers
                    for (const auto &paper : levelData[paperRequirement]) 
                    {
                        std::cout << paper << std::endl;
                        if (completedSet.find(paper) != completedSet.end()) 
                        {
                            missingNOfPapers -= 1;
                            completedNOfPoints += 18;
                        }
                    }
                    if(missingNOfPapers > 0){
                        feedback[paperRequirement] = missingNOfPapers;
                    }
                }
            }
        }
    }

    std::cout << completedSet.size() << std::endl;
    int completedPoints = completedSet.size() * 18;
    std::cout << "completedPoints: " << completedPoints << std::endl;

    if (completedPoints < 360) 
    {
        feedback["remaining_points"] = 360 - completedPoints;
    }

    std::cout << "9" << std::endl;

    if (majorData.contains("further_points")) 
    {
        int furtherPoints = majorData["further_points"];
        int electivePoints = furtherPoints - completedElectivePoints;
        feedback["remaining_points_at_200-level"] = furtherPoints;  // This needs to be adapted if 360 isn't the total points for the degree
    }

    // if (majorData.contains("remaining_points")) 
    // {
    //     int remainingPoints = majorData["remaining_points_at_200-level"];
    //     feedback["remaining_points_at_200-level"] = 360 - further_points;  // This needs to be adapted if 360 isn't the total points for the degree
    // }

    return feedback;
}

std::string DegreeRequirements::intToWord(int num) 
{
    switch(num) 
    {
        case 1: return "one";
        case 2: return "two";
        case 3: return "three";
        case 4: return "four";
        case 5: return "five";
        case 6: return "six";
        default: return ""; // handle invalid input or extend as needed
    }
}
