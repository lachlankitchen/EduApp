from bs4 import BeautifulSoup
import requests
import json

# Create an empty list to store the URLs
degree_urls = []

# Open the file in read mode
with open('../Data/degree_urls.txt', 'r') as file:
    # Read each line of the file and add it to the list
    for line in file:
        degree_urls.append(line.strip())

# Create an empty dictionary to store the requirements for each degree
requirements = {}

# Base URL
base_url = "https://www.otago.ac.nz"

# Loop through the URLs
for degree_url in degree_urls:
    # Append the degree URL to the base URL
    url = base_url + degree_url

    # Send a request to the URL and get the content of the page
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    program_name_element = soup.select('div.titleinner > h1')
    print(program_name_element)
    if program_name_element:
        program_name = program_name_element[0].text.strip()
        print(f"Scraping data for {program_name}...")
    else:
        program_name = "degreeProgramme"
        print(f"Scraping data for degreeProgramme...")
    total_points = None
    points_above_100_level = None
    points_above_200_level = None
    required_papers = []
    majors =[]
    if "Bachelor" in program_name:
        # Use the select method to find the element using the CSS selector
        element = soup.select("#content > ol > li:nth-child(1)")

        # Check if the element was found
        if element:
            text_line = element[0].text
        else:
            text_line = ""

        # Parse the text line to extract the relevant information
        try:
            total_points = int(text_line.split("not less than ")[1].split(" points")[0])
        except:
            total_points = None

        try:
            points_above_100_level = int(text_line.split("at least ")[1].split(" points")[0])
        except:
            points_above_100_level = None

        try:
            points_above_200_level = int(text_line.split("at least ")[2].split(" points")[0])
        except:
            points_above_200_level = None

        try:
            required_papers = text_line.split("Required Papers*: ")[1].split(", ")
        except:
            required_papers = []

        majors_element = soup.select("#content > ul:nth-child(11)")
        program_name_element = soup.find("h1", class_="notopimage")



        # Extract the majors
        majors_element = soup.select("#content > ul:nth-child(11)")
        if majors_element:
            list_items = majors_element[0].find_all("li")
            majors = [item.text.strip() for item in list_items]
        else:
            majors = []

        # Print the program name to show the progress of the web scraping
        print(f"URL: {url}, Program Name: {program_name}")

    # Add the requirements for the current degree to the dictionary
    requirements[program_name] = {
        "minimumTotalPoints": total_points,
        "minimumPointsAbove100Level": points_above_100_level,
        "minimumPointsAbove200Level": points_above_200_level,
        "requiredPapers": required_papers,
        "availableMajors": majors
    }

# Convert the dictionary to JSON format
requirements_json = json.dumps(requirements, indent=4, ensure_ascii=False)

# Save the JSON data to a file
with open("../Data/requirements.json", "w", encoding="utf-8") as file:
    file.write(requirements_json)
