from typing import List, Dict

CAREER_MAP = {
    "Python": "Data Scientist",
    "Flutter": "Mobile Developer",
    "Laravel": "Backend Developer",
}

STUDY_RESOURCES = {
    "Data Scientist": [
        "Belajar DS di Dicoding",
        "Google Data Analytics",
    ],
    "Mobile Developer": [
        "Flutter Official Documentation",
        "Learn Dart Basics",
    ],
    "Backend Developer": [
        "Laravel for Beginners",
        "PHP Official Docs",
    ],
}

def recommend_career(skills: List[str]) -> Dict[str, List[str]]:
    """Return career and study recommendations based on provided skills."""
    for skill in skills:
        for keyword, career in CAREER_MAP.items():
            if keyword.lower() in skill.lower():
                return {
                    "career": career,
                    "recommendations": STUDY_RESOURCES.get(career, []),
                }
    return {"career": "Generalist", "recommendations": ["Explore general courses"]}
