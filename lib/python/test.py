import requests
from bs4 import BeautifulSoup
import json
import re

text_to_number = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5
}


def single():
    return 0


def process_rows(items):
    compulsory_papers = []
    optional_papers = []

    for item in items[1:-2]:
        level = item.find('td').text.strip()
        p_elements = item.find_all('p')
        if len(p_elements) == 0:
            single()
            continue

    print(p_elements)
    return


def setup():
    url = "https://www.otago.ac.nz/courses/qualifications/ba.html"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    # Outline of papers and points needed to complete a Bachelor of Arts majoring in Anthropology
    # Outline of papers and points needed to complete a Bachelor of Arts majoring in Computer Science
    table = soup.find('table',
                      summary='Outline of papers and points needed to complete a Bachelor of Arts majoring in Anthropology')

    rows = table.find_all('tr')
    process_rows(rows)
    qualification = soup.find('h3').text.split('(')[0].strip()
    major = soup.find('h3').text.split('majoring in ')[1].strip()
    data = {
        "qualification": qualification,
        "major": major,
        "levels": []
    }


# for row in rows[1:]:
#     compulsory_papers = []
#     optional_papers = []
#     print("LEVEL:" + level)
#     p_elements = row.find_all('p')
#     if len(p_elements) == 0:
#         a_tags = row.find_all('a')
#         print(a_tags)
#     for p in p_elements:
#         if 'smalltag' in p.text:
#             continue
#         # Get a list of all the <a> tags within the <p> element
#         a_tags = p.find_all('a')
#         #print(a_tags)
#         # check if its the only a element in a given p. if so then it must be a complusary paper
#         if len(a_tags) == 1:
#             a_tag = a_tags[0]
#             paper_code = a_tag['href'].split('=')[-1]
#             compulsory_papers.append(paper_code)
#         else:
#             #Get the text content of the <p> element
#             p_text = p.text.lower()
#             # Create a regular expression pattern that matches the word 'of'
#             pattern = r'\bof\b'
#             # Check if the pattern is found in the text content of the <p> element
#             if re.search(pattern, p_text):
#                 pattern = r'\b(one|two|three|four|five)\b'
#                 match = re.search(pattern, p.text, flags=re.IGNORECASE)
#                 number = text_to_number.get(match.group().lower(), None)
#                 optional_papers.append(number)
#                 for a_tag in a_tags:
#                     paper_code = a_tag['href'].split('=')[-1]
#                     #print(paper_code)
#                     optional_papers.append(paper_code)
#                     # print(optional_papers)
#                     #add to paper list to level and then add level to the json array
#                     # evaluate how we are going to store the papers in the one of array
#                     # can we store different things in an array ??
#                     # i think we can and therefore we could store the number of requested papers in the array in the 0 position
#                     #that way it wouldnt matter which is which
#             else:
#                 count = 0
#
#
#     print("Complusary Papers: ", compulsory_papers)
#     print("Optional Papers: ", optional_papers)
#                     #print("Did not find 'of'")
#
#
#                 #print(optional_papers)
#     # if "One of" in p.text:
#     #     one_of_papers.append(paper_code)
#     # else:
#     #             compulsory_papers.append(paper_code)
#
#     #print("Compulsory papers:", compulsory_papers)
#     #print("One of papers:", one_of_papers)
#
#    # further
#    # any
#    # of
#     #®print(papers)
#     # data["levels"].append({
#     #     "level": level,
#     #     "compulsory_papers": papers[:-1],
#     #     "one_of_papers": papers[-1].split(", "),
#     #     "points": points
#     # })
# json_data = json.dumps(data, indent=4)
# print(json_data)


def main():
    setup()
    print("This is the main method!")


# This checks if the script is being run directly (not imported)
if __name__ == "__main__":
    main()
