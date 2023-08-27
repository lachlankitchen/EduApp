from bs4 import BeautifulSoup
import requests
import json

# Send a request to the URL and get the content of the page
url = "https://www.otago.ac.nz/study/otago618684.html"
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Create an empty dictionary to store the overall headings and their corresponding subjects
headings = {}

# Find all the h2 elements on the page
h2_elements = soup.find_all('h3')

# Loop through the h2 elements
for h2_element in h2_elements:
    # Get the text content of the h2 element
    overall_heading = h2_element.text.strip()

    # Create an empty list to store the subjects
    subjects_list = []

    # Find all the h3 elements after the current h2 element
     # Find the next table element after the current h3 element
    table_element = h2_element.find_next('table')

    # Create an empty list to store the papers
    papers_list = []

    # Check if the table element was found
    if table_element:
        # Find all the tr elements within the table element
        tr_elements = table_element.find_all('tr')

        # Loop through the tr elements
        for tr_element in tr_elements:
            # Find all the td elements within the tr element
            td_elements = tr_element.find_all('td')

            # Check if there are at least two td elements
            if len(td_elements) >= 2:
                # Get the text content of the first and second td elements
                paper_name = td_elements[0].text.strip()
                paper_code = td_elements[1].text.strip()

                # Add the paper code and name to the list of papers
                papers_list.append({"paperName": paper_name, "paperCode": paper_code})



    # Add the overall heading and its corresponding subjects to the dictionary of overall headings
    headings[overall_heading] = papers_list

# Convert the dictionary to JSON format
headings_json = json.dumps(headings, indent=4)

# Save the JSON data to a file
with open("../Data/headings.json", "w", encoding="utf-8") as file:
    file.write(headings_json)
