from bs4 import BeautifulSoup
import requests
import time
import re
# URL of the page containing the list of degrees
url = "https://www.otago.ac.nz/courses/qualifications/"

# Send a request to the URL and get the content of the page
response = requests.get(url)
soup = BeautifulSoup(response.text, 'html.parser')

# Create an empty list to store the URLs
degree_urls = []

# Find the headings that say "Undergraduate"
headings = soup.find_all('h3', string=re.compile(r'Undergraduate', re.IGNORECASE))

print(headings)
time.sleep(5)
# Loop through the headings and select the ul element that immediately follows each heading
for heading in headings:
    ul = heading.find_next('ul')
    if ul:
        # Find the elements containing the URLs for the undergraduate degrees
        degree_elements = ul.select("li > a")
        for element in degree_elements:
            # Get the URL from the 'href' attribute of the element
            degree_url = element['href']

            # Add the URL to the list
            degree_urls.append(degree_url)

# Print the list of URLs
# Assuming you have a list of URLs called degree_urls

# Open a file in write mode
with open('../Data/degree_urls.txt', 'w') as file:
    # Write each URL to the file on a new line
    for url in degree_urls:
        file.write(url + '\n')

