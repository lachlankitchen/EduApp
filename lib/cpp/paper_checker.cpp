#include <nlohmann/json.hpp>
#include <iostream>
#include <unordered_set>

using namespace std;

class DegreeRequirements
{
private:
    nlohmann::json degreeData;

public:
    DegreeRequirements(const string &jsonData)
    {
        degreeData = nlohmann::json::parse(jsonData);
    }

    bool checkRequirements(const vector<string> &completedPapers)
    {
        unordered_set<string> completedSet(completedPapers.begin(), completedPapers.end());

        for (const auto &majorEntry : degreeData.items())
        {
            const string &majorName = majorEntry.key();
            const nlohmann::json &majorData = majorEntry.value();

            cout << "Checking requirements for major: " << majorName << endl;

            if (majorData.contains("levels"))
            {
                for (const auto &levelEntry : majorData["levels"].items())
                {
                    const string &levelName = levelEntry.key();
                    const nlohmann::json &levelData = levelEntry.value();

                    cout << "Checking requirements for level: " << levelName << endl;

                    // Check compulsory papers
                    if (levelData.contains("compulsory_papers"))
                    {
                        for (const auto &paper : levelData["compulsory_papers"])
                        {
                            if (completedSet.find(paper) == completedSet.end())
                            {
                                cout << "Missing compulsory paper: " << paper << endl;
                                return false;
                            }
                        }
                    }

                    // Check 'one_of_papers' through 'six_of_papers'
                    for (int i = 1; i <= 6; i++)
                    {
                        string paperRequirement = to_string(i) + "_of_papers";
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
                                cout << "Must complete at least " << i << " of the papers in the list for " << levelName << endl;
                                return false;
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

                int totalPoints = completedPapers.size() * 18; // Assuming each paper is 18 points
                if (totalPoints < remainingPoints)
                {
                    cout << "Total points not met for major " << majorName << ". Required: " << remainingPoints << ", Achieved: " << totalPoints << endl;
                    return false;
                }

                if (totalPoints < pointsAtLevel)
                {
                    cout << "Total points not met at 200-level for major " << majorName << ". Required: " << pointsAtLevel << ", Achieved: " << totalPoints << endl;
                    return false;
                }
            }
        }

        return true;
    };
};

int main()
{
    // Example usage
    string jsonData = R"({
        "Anthropology": {
            "levels": {
                "100-level": {
                    "two_of_papers": [
                        "ANTH103",
                        "ANTH105",
                        "ANTH106"
                    ]
                },
                "200-level": {
                    "one_of_papers": [
                        "ANTH203",
                        "ANTH204",
                        "ANTH205",
                        "ANTH206",
                        "ANTH208",
                        "ANTH209",
                        "ANTH210",
                        "ANTH211",
                        "ANTH222",
                        "ANTH223",
                        "ANTH225",
                        "ANTH228",
                        "ANTH231",
                        "BIOA201",
                        "GEND201",
                        "GEND205",
                        "GEND206",
                        "GEND207",
                        "GEND208",
                        "GEND209",
                        "GEND210",
                        "GEND234",
                        "GEOG210",
                        "GLBL211",
                        "MUSI268",
                        "SOCI201",
                        "SOCI202",
                        "SOCI203",
                        "SOCI204",
                        "SOCI205",
                        "SOCI207",
                        "SOCI208",
                        "SOCI209",
                        "SOCI211",
                        "SOCI213"
                    ],
                    "two_of_papers": [
                        "ANTH203",
                        "ANTH204",
                        "ANTH205",
                        "ANTH206",
                        "ANTH208",
                        "ANTH209",
                        "ANTH210",
                        "ANTH211",
                        "ANTH222",
                        "ANTH223",
                        "ANTH225",
                        "ANTH228",
                        "ANTH231",
                        "BIOA201",
                        "GEND201",
                        "GEND205",
                        "GEND206",
                        "GEND207",
                        "GEND208",
                        "GEND209",
                        "GEND210",
                        "GEND234",
                        "GEOG210",
                        "GLBL211",
                        "MUSI268",
                        "SOCI201",
                        "SOCI202",
                        "SOCI203",
                        "SOCI204",
                        "SOCI205",
                        "SOCI207",
                        "SOCI208",
                        "SOCI209",
                        "SOCI211",
                        "SOCI213"
                    ]
                },
                "300-level": {
                    "four_of_papers": [
                        "ANTH310",
                        "ANTH312",
                        "ANTH317",
                        "ANTH321",
                        "ANTH322",
                        "ANTH323",
                        "ANTH324",
                        "ANTH325",
                        "ANTH326",
                        "ANTH327",
                        "ANTH328",
                        "ANTH329",
                        "ANTH330",
                        "BIOA301",
                        "GEND305",
                        "GEND306",
                        "GEND307",
                        "GEND308",
                        "GEND309",
                        "GEND310",
                        "GEND311",
                        "GEND334",
                        "GEOG381",
                        "GLBL311",
                        "MUSI368",
                        "MUSI386",
                        "SOCI301",
                        "SOCI302",
                        "SOCI304",
                        "SOCI305",
                        "SOCI306",
                        "SOCI309",
                        "SOCI310",
                        "SOCI312",
                        "SOCI313",
                        "SOCI319"
                    ]
                }
            },
            "remaining_points": 198,
            "points_at_200-level": 54
        }
    })";

    vector<string> completedPapers = {"ANTH103", "ANTH203", "ANTH310"};

    DegreeRequirements degree(jsonData);
    bool requirementsMet = degree.checkRequirements(completedPapers);

    if (requirementsMet)
    {
        cout << "All requirements met!" << endl;
    }

    return 0;
}
