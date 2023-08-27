import os

import requests
from bs4 import BeautifulSoup
import pickle
from dataclasses import dataclass, field
from typing import List
import json
import re


@dataclass
class Paper:
    paper_code: str = field(default='')
    subject_code: str = field(default='')
    year: str = field(default='')
    title: str = field(default='')
    description: str = field(default='')
    efts: str = field(default='')
    points: str = field(default='')
    teaching_periods: List[str] = field(default_factory=list)
    course_outline: str = field(default='')
    prerequisites: str = field(default='')  # Added
    restrictions: str = field(default='')   # Added
    schedule: str = field(default='')


def get_more_data(papers):

    count = 0
    for paper in papers:
        url = f"https://www.otago.ac.nz/courses/papers/index.html?papercode={paper}"
        soup = None
        try:
            response = requests.get(url)
            soup = BeautifulSoup(response.text, 'html.parser')
        except:
            continue
        description = ""
        try:
            description = "\n".join(p.text for p in soup.find_all(
                "p", class_=["prescription", "MARKETING"]))
        except:
            pass

        subject_code = ""

        try:
            subject_code = soup.find(
                "tr", class_="subject_code").find("td").text
        except:
            pass
        efts = ""
        try:
            efts = soup.find("tr", class_="efts").find("td").text
        except:
            pass


        prerequisite, restriction = None, None
        try:
            # Find all elements with the 'COMP' class
            comp_elements = soup.find_all(class_="COMP")
            comp_data = {}

            for i in range(0, len(comp_elements) - 1, 2):
                key_element = comp_elements[i]
                value_element = comp_elements[i + 1]

                key = key_element.text.strip() if key_element else None
                value = value_element.text.strip() if value_element else None

                if key:
                    comp_data[key] = value

            prerequisite = comp_data.get('Prerequisite')
            #print(prerequisite)
            restriction = comp_data.get('Restriction')
            #print(restriction)

            # Schedule (kept as before)
            schedule_dd = soup.find("dd", class_="Sched")
            schedule = schedule_dd.text if schedule_dd else None
        except:

            pass

        # Assign values to your paper object's attributes
        papers[paper].description = description
        papers[paper].subject_code = subject_code
        papers[paper].efts = efts
        papers[paper].schedule = schedule
        papers[paper].restriction = restriction
        papers[paper].prerequisite = prerequisite

        count += 1
        print("Done paper:", paper, "Papers Completed:", count, "of 1794")


def get_paper_data(period):
    url = f"https://www.otago.ac.nz/courses/papers/index.html?subjcode=*&papercode=*&keywords=*&period={period}&year=2023&distance=&lms=&submit=Search"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    table = soup.find("table", class_="paper_search_results")

    papers = {}
    for row in table.find_all("tr")[1:]:
        cells = row.find_all("td")
        paper_code = cells[0].text.strip()
        year = "2023"
        title = cells[2].text.strip()
        points = cells[3].text.strip().split()[0]
        teaching_period = period

        print("title", title, "year", year)
        if paper_code not in papers:
            papers[paper_code] = Paper(
                paper_code=paper_code, year=year, title=title, points=points, teaching_periods=[teaching_period])

        else:
            papers[paper_code].teaching_periods.append(teaching_period)

    return papers


def get_papers(all_papers):
    #periods = ["S1"]
    periods = ["S1", "S2", "FY", "SS"]
    for period in periods:
        new_papers = get_paper_data(period)
        for paper_code, paper in new_papers.items():
            if paper_code not in all_papers:
                all_papers[paper_code] = paper
            else:
                all_papers[paper_code].teaching_periods.extend(
                    paper.teaching_periods)



def clean_email(email):
    clean_email = re.match(r"(.*\.ac\.nz)", email)
    return clean_email.group(0) if clean_email else email


def clean_description(description):
    description = description.replace("\n", " ")
    description = re.sub(r'\s+', ' ', description).strip()
    return description


def clean_data(all_papers):
    for paper_code, paper in all_papers.items():
        paper.description = clean_description(paper.description)


def save_data_to_json(all_papers):
    papers_data = {}

    for paper_code, paper in all_papers.items():
        paper_dict = {
            "subject_code": paper.subject_code,
            "year": "2023",
            "title": paper.title,
            "points": paper.points,
            "efts": paper.efts,
            "teaching_periods": paper.teaching_periods,
            "description": paper.description,
            "prerequisites": paper.prerequisite,
            "restrictions": paper.restriction,
            "schedule": paper.schedule
        }
        papers_data[paper.paper_code] = paper_dict

    with open("../Data/papers_data.json", "w") as papers_file:
        json.dump(papers_data, papers_file, indent=2)

if __name__ == "__main__":

    all_papers = {}
    print("Script started")

    try:
        print("Script started")
        with open("../Data/papercodes.pickle", "rb") as f:
            #print("hello")
            all_papers = pickle.load(f)
            #print(all_papers)
            clean_data(all_papers)
            #print(all_papers)
            save_data_to_json(all_papers)
            # create_teaching_staff_json(all_papers)
            print("hello")

    except FileNotFoundError:
        print("getting papers")
        get_papers(all_papers)
        get_more_data(all_papers)
        with open("../Data/papercodes.pickle", "wb") as f:
            pickle.dump(all_papers, f)
    pass
