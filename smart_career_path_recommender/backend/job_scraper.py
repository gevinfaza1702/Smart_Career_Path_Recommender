import csv
import requests
from bs4 import BeautifulSoup

BASE_URL = "https://glints.com"
SEARCH_URL = f"{BASE_URL}/id/opportunities/jobs/explore"

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
                  "(KHTML, like Gecko) Chrome/90.0 Safari/537.36"
}


def scrape_jobs(keyword="Data Scientist", limit=10):
    """Scrape job listings from Glints search results."""
    params = {"keyword": keyword}
    resp = requests.get(SEARCH_URL, params=params, headers=HEADERS)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    jobs = []
    cards = soup.select("div[data-testid='job-card']")
    for card in cards[:limit]:
        title = card.select_one("h3")
        company = card.select_one("div[data-testid='company-name']")
        location = card.select_one("div[data-testid='job-location']")
        link_tag = card.find("a", href=True)
        detail_url = BASE_URL + link_tag['href'] if link_tag else None

        description = ""
        if detail_url:
            d_resp = requests.get(detail_url, headers=HEADERS)
            d_resp.raise_for_status()
            d_soup = BeautifulSoup(d_resp.text, "html.parser")
            desc_el = d_soup.select_one("div[data-testid='job-description']")
            if desc_el:
                description = desc_el.get_text(strip=True)

        jobs.append({
            "title": title.get_text(strip=True) if title else "",
            "company": company.get_text(strip=True) if company else "",
            "location": location.get_text(strip=True) if location else "",
            "description": description,
        })
    return jobs


def save_jobs(jobs, filename="jobs.csv"):
    with open(filename, "w", newline="", encoding="utf-8") as csvfile:
        fieldnames = ["title", "company", "location", "description"]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for job in jobs:
            writer.writerow(job)


if __name__ == "__main__":
    data = scrape_jobs()
    save_jobs(data)
