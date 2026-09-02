#! /usr/bin/env python3

import argparse
import shutil
import subprocess
import tempfile
from multiprocessing import Process, Queue
from pathlib import Path
from typing import TypedDict

Status = TypedDict("Status", {"message": str})


def generate_resume(resume: Path, design: Path, locale: Path, output: Path, message_queue: Queue[Status]) -> None:
    resume_name: str = resume.stem.upper() if resume.stem == "cv" else resume.stem.capitalize()
    pdf_path: Path = output / f"Lucas-Hoz-{resume_name}.pdf"

    try:
        subprocess.run(
            args=[
                "rendercv",
                "render",
                str(object=resume),
                "--design",
                str(object=design),
                "--locale-catalog",
                str(object=locale),
                "--pdf-path",
                str(object=pdf_path),
                "--typst-path",
                str(object=Path(tempfile.gettempdir()) / pdf_path.stem),
                "--dont-generate-png",
                "--dont-generate-html",
                "--dont-generate-markdown",
                "--quiet",
            ],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        message_queue.put({"message": f'\033[32m- Resume "{pdf_path.name}" generated successfully.\033[0m'})
    except subprocess.CalledProcessError:
        message_queue.put({"message": f'\033[31m- An error occurred on generate "{pdf_path.name}".\033[0m'})


def main() -> None:
    # Parse arguments
    parser = argparse.ArgumentParser(description="Generate resumes in different languages for each design.")
    parser.parse_args()

    root_directory: Path = Path(__file__).resolve().parent.parent
    resumes_directory: Path = root_directory / "resumes"

    output_directory: Path = resumes_directory / ".dist"
    locales_directory: Path = resumes_directory / "locales"
    designs_directory: Path = resumes_directory / "designs"

    # Clean up the distribution directory before generating new resumes
    shutil.rmtree(output_directory, ignore_errors=True)

    # Generate resumes
    queue: Queue[Status] = Queue()
    resumes: list[Process] = []

    for design in designs_directory.iterdir():
        spanish_resume = Process(
            target=generate_resume,
            args=(resumes_directory / "cv.yaml", design, locales_directory / "spanish.yaml", output_directory, queue),
        )

        english_resume = Process(
            target=generate_resume,
            args=(
                resumes_directory / "resume.yaml",
                design,
                locales_directory / "english.yaml",
                output_directory / design.stem,
                queue,
            ),
        )

        spanish_resume.start()
        english_resume.start()

        resumes.append(spanish_resume)
        resumes.append(english_resume)

    for resume in resumes:
        resume.join()
        print(queue.get()["message"])


if __name__ == "__main__":
    main()
