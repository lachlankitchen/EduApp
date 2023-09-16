#include "httplib.h"
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>

int main(void)
{
  using namespace httplib;

  Server svr;

  svr.Get("/degrees", [](const Request &req, Response &res)
          {
       std::filesystem::path json_file_path = "../../../data/degrees.json"; // Specify the correct path to your JSON file
       if (!std::filesystem::exists(json_file_path)) {
           res.status = 404;
           res.set_content("File not found", "text/plain");
           std::cout << "File not found at specified path.\n";
           return;
       }

       std::ifstream json_file(json_file_path);
       std::string json_content((std::istreambuf_iterator<char>(json_file)),
                                std::istreambuf_iterator<char>());

       res.set_header("Access-Control-Allow-Origin", "*");
       res.set_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type");
       res.set_content(json_content, "application/json");

       std::cout << "Successfully served the JSON file.\n"; 
  });

  svr.Get("/major/{degrees}", [](const Request &req, Response &res){
  
  }

  svr.Get("/paper/{paperCode}", [](const Request &req, Response &res){
  
  }


  svr.Get("/userPaperList", [](const Request &req, Response &res){
  
  }
}