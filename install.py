#!/usr/bin/env python3

import os
import shutil

THIS_PATH = os.path.realpath(__file__)
THIS_DIR = os.path.dirname(THIS_PATH)
HOME_DIR = os.environ.get("HOME")

assert THIS_DIR, "Expected a non-empty path."
assert THIS_DIR != '/', "Expected a non-root path."
assert HOME_DIR, "'HOME' environment variable expected."

FILE_AND_FOLDERS_TO_COPY = [
    (".vscode", HOME_DIR),
    (".bashrc", HOME_DIR),
    (".bash_custom", HOME_DIR),
]

if __name__ == "__main__":
    print("Installing...")
    for f, target_dir in FILE_AND_FOLDERS_TO_COPY:
        p_orig = os.path.join(THIS_DIR, f)
        p_target = os.path.join(target_dir, f)
        print("   Copy [{}] to [{}]".format(p_orig, p_target))

        if os.path.isdir(p_orig):
            _ = shutil.copytree(
                p_orig, p_target,
                dirs_exist_ok=True
            )
        else:
            _ = shutil.copy(p_orig, p_target)
