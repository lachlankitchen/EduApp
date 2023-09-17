#include "lib/cpp/paper_checker.h" // Replace with the actual path to your C++ file
#include <gtest/gtest.h>

TEST(DegreeRequirementsTest, CheckRequirements) {
    // Test case 1: All requirements met
    std::string jsonData = R"({
        "total": 162,
        "levels": [
            {
                "level": "100-level",
                "compulsory_papers": ["COMP 101", "MATH 120"],
                "one_of_papers": ["COMP 161", "COMP 162"]
            },
            {
                "level": "200-level",
                "compulsory_papers": ["COSC 201", "COSC 202"],
                "one_of_papers": ["COSC 203", "COSC 204"]
            }
        ]
    })";
    DegreeRequirements dr(jsonData);
    std::vector<std::string> completedPapers = {
        "COMP 101", "COMP 161", "COMP 162", "MATH 120", "COSC 201", "COSC 202", "COSC 203", "COSC 204", "COSC 326"
    };
    EXPECT_TRUE(dr.checkRequirements(completedPapers));

    // Test case 2: Missing compulsory paper
    completedPapers.pop_back(); // Remove "COSC 326" to simulate missing a compulsory paper
    EXPECT_FALSE(dr.checkRequirements(completedPapers));

    // Test case 3: Not enough total points
    jsonData = R"({
        "total": 180,
        "levels": [
            {
                "level": "100-level",
                "compulsory_papers": ["COMP 101", "MATH 120"],
                "one_of_papers": ["COMP 161", "COMP 162"]
            },
            {
                "level": "200-level",
                "compulsory_papers": ["COSC 201", "COSC 202"],
                "one_of_papers": ["COSC 203", "COSC 204"]
            }
        ]
    })";
    DegreeRequirements dr2(jsonData);
    EXPECT_FALSE(dr2.checkRequirements(completedPapers));
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
