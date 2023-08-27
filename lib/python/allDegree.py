import requests
from bs4 import BeautifulSoup
import re
degree_urls =[]
with open('../Data/degree_urls.txt', 'r') as file:
    # Read each line of the file and add it to the list
    for line in file:
        degree_urls.append(line.strip())
    base_url = "https://www.otago.ac.nz"

    for degree_url in degree_urls:
        results = {}
        number = 0
        try:
            max_id = 3000
            url = base_url + degree_url
            response = requests.get(url)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')
            pattern = re.compile(r'qualification.*')

            h3_elements = soup.find_all('h3', {'id':pattern})
            if not h3_elements:
                print(url)
            print(h3_elements)
            headings = [h3.text.strip() for h3 in h3_elements]
        except requests.exceptions.RequestException as e:
            print(f"Error fetching URL {url}: {e}")

print(results)
