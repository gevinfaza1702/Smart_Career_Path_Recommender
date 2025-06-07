import pandas as pd
import spacy
from collections import Counter
from spacy.matcher import PhraseMatcher

KNOWN_SKILLS = [
    "python", "sql", "flutter", "dart", "laravel",
    "php", "java", "machine learning", "statistics", "mysql"
]

def extract_skills(descriptions):
    nlp = spacy.load("en_core_web_sm")
    matcher = PhraseMatcher(nlp.vocab, attr="LOWER")
    patterns = [nlp.make_doc(skill) for skill in KNOWN_SKILLS]
    matcher.add("SKILL", patterns)
    found = []
    for doc in nlp.pipe(descriptions):
        matches = matcher(doc)
        for _, start, end in matches:
            found.append(doc[start:end].text)
    return Counter(found)

if __name__ == "__main__":
    df = pd.read_csv("jobs.csv")
    if "description" not in df.columns:
        raise ValueError("jobs.csv must have a 'description' column")
    counts = extract_skills(df["description"].astype(str))
    for skill, cnt in counts.most_common(5):
        print(f"{skill}: {cnt}")
