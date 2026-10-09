#!/usr/bin/env python3
"""Select visible URLs and OSC 8 targets from a tmux pane on macOS."""

import re
import subprocess
import sys


URL_PATTERN = re.compile(r"(?:https?://|ftp://|file://|www\.)[^\s<>\"'`\x1b│]+")
HISTORY_START = "-2000"


def extract_urls(text):
    for match in URL_PATTERN.finditer(text):
        url = match.group().rstrip(".,;!")
        # Remove prose delimiters, but keep balanced URL parentheses/brackets.
        while url and url[-1] in ")]}":
            closing = url[-1]
            opening = {")": "(", "]": "[", "}": "{"}[closing]
            if url.count(closing) <= url.count(opening):
                break
            url = url[:-1].rstrip(".,;!")
        if url.startswith("www."):
            url = "https://" + url
        yield url


def capture_urls(pane):
    common = ["tmux", "capture-pane", "-p", "-S", HISTORY_START, "-t", pane]
    text = subprocess.check_output(common + ["-J"], text=True)
    # tmux 3.7+: -H exports targets even when the visible label is not a URL.
    hyperlinks = subprocess.check_output(common + ["-H"], text=True)
    return list(dict.fromkeys([*extract_urls(text), *hyperlinks.split()]))


def notify(pane, message):
    subprocess.run(["tmux", "display-message", "-t", pane, message], check=True)


def main(pane):
    urls = capture_urls(pane)
    if not urls:
        notify(pane, "Links: no URLs in the current screen or last 2000 history lines")
        return

    result = subprocess.run(
        [
            "fzf",
            "--no-tmux",
            "--height=100%",
            "--layout=reverse",
            "--no-sort",
            "--no-multi",
            "--no-preview",
            "--prompt=URL> ",
            "--header=Enter: open | Ctrl-y: copy | Esc: cancel",
            "--expect=enter,ctrl-y",
        ],
        input="\n".join(urls) + "\n",
        text=True,
        stdout=subprocess.PIPE,
    )
    if result.returncode in (1, 130):
        return
    result.check_returncode()
    key, url = result.stdout.splitlines()
    if key == "ctrl-y":
        subprocess.run(["pbcopy"], input=url, text=True, check=True)
        notify(pane, "Links: copied URL to clipboard")
    else:
        # Pass the URL as an argument, never interpolate it into a shell command.
        subprocess.run(["open", "--", url], check=True)
        notify(pane, "Links: opened URL")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: tmux-url-picker.py PANE_ID")
    try:
        main(sys.argv[1])
    except (OSError, subprocess.CalledProcessError) as error:
        notify(sys.argv[1], f"Links: {error}")
        raise SystemExit(1)
