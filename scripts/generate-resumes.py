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
    pdf_path: Path = output / f"Lucas-Hoz-{'CV' if locale.stem == 'spanish' else 'Resume'}.pdf"

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

        message_queue.put(obj={"message": f'\033[32m- Resume "{pdf_path.name}" generated successfully.\033[0m'})
    except subprocess.CalledProcessError:
        message_queue.put(obj={"message": f'\033[31m- An error occurred on generate "{pdf_path.name}".\033[0m'})


def main() -> None:
    # Parse arguments
    parser = argparse.ArgumentParser(
        description="Generate resumes in different languages for each design, unless a specific resume and locale are provided."
    )

    parser.add_argument("-r", "--resume", type=Path, help="path to the resume YAML file to generate")
    parser.add_argument(
        "-l", "--locale", type=str, choices=["spanish", "english"], help="locale to use for generating the resume"
    )

    arguments: argparse.Namespace = parser.parse_args()

    if arguments.resume and not arguments.locale:
        parser.error(message="The `--locale` argument is required when using the `--resume` argument.")
    elif not arguments.resume and arguments.locale:
        parser.error(message="The `--resume` argument is required when using the `--locale` argument.")

    # Change from script directory to project root directory
    root_directory: Path = Path(__file__).resolve().parent.parent

    # Define directories
    resumes_directory: Path = root_directory / "resumes"
    output_directory: Path = resumes_directory / ".dist"
    locales_directory: Path = resumes_directory / "locales"
    designs_directory: Path = resumes_directory / "designs"

    # Clean up the distribution directory before generating new resumes
    shutil.rmtree(output_directory, ignore_errors=True)

    # Generate resumes
    resumes: list[tuple[Path, Path]] = (
        [(arguments.resume, locales_directory / f"{arguments.locale}.yaml")]
        if arguments.resume
        else [
            (resumes_directory / "cv.yaml", locales_directory / "spanish.yaml"),
            (resumes_directory / "resume.yaml", locales_directory / "english.yaml"),
        ]
    )

    processes: list[Process] = []
    message_queue: Queue[Status] = Queue()

    for design in designs_directory.iterdir():
        for resume, locale in resumes:
            process = Process(target=generate_resume, args=(resume, design, locale, output_directory, message_queue))
            process.start()
            processes.append(process)

    for process in processes:
        process.join()
        print(message_queue.get()["message"])


if __name__ == "__main__":
    main()
