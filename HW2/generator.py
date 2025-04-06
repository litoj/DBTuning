import csv
import random
import string
from faker import Faker
from tqdm import tqdm
from faker.providers.person.en import Provider

first_names = list(set(Provider.first_names))
last_names = list(set(Provider.last_names))


# Faker instance for random data
data_gen = Faker()


def random_string(length=8):
    return "".join(random.choices(string.ascii_letters, k=length))


fn_idx = -1
ln_idx = 0


def gen_name():
    global fn_idx, ln_idx
    name = "too_long_to_be_used"
    while len(name) > 16:
        fn_idx += 1
        if fn_idx >= len(first_names):
            fn_idx = 0
            ln_idx += 1
        name = first_names[fn_idx] + " " + last_names[ln_idx]
    return name


def generate_csv():
    # Generate Tech Departments CSV
    deptCount = 10
    tech_depts = [f"TechDept{i}" for i in range(1, deptCount + 1)]
    with open("techdept.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["dept", "manager", "location"])
        locations = [
            "Berlin-Mitte",
            "Berlin-Kreuzberg",
            "Vienna-01",
            "Vienna-10",
            "Salzburg",
            "Munich",
            "Hamburg",
            "Berlin-Neukolln",
            "Graz",
            "Zurich",
            "Innsbruck",
        ]
        managers = random.sample(range(1, 100000), 10)
        writer.writerows(
            [(tech_depts[i], managers[i], locations[i]) for i in range(deptCount)]
        )

    # Generate Employees CSV
    with open("employee.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["ssnum", "name", "manager", "dept", "salary", "numfriends"])
        for i in tqdm(range(1, 100001), desc="Generating Employees"):
            ssnum = i
            name = gen_name()
            manager = random.randint(1, i - 1) if i > 1 else None
            dept = random.choice(tech_depts) if random.random() < 0.1 else None
            salary = round(random.uniform(30000, 150000), 2)
            numfriends = random.randint(0, 50)
            writer.writerow([ssnum, name, manager, dept, salary, numfriends])

    # Generate Students CSV
    with open("student.csv", "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["ssnum", "name", "course", "grade"])
        courses = ["Math", "Physics", "Chemistry", "Computer Science", "Biology"]
        for i in tqdm(range(1, 100001), desc="Generating Students"):
            ssnum = i
            name = gen_name()
            course = random.choice(courses)
            grade = round(random.uniform(1.0, 5.0), 2)
            writer.writerow([ssnum, name, course, grade])

    print("✅ CSV files generated successfully!")


generate_csv()
