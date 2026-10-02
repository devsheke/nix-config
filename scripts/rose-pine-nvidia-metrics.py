#!/usr/bin/env python3
"""Read one bounded NVIDIA telemetry sample; never change GPU configuration."""

import csv
import io
import json
import math
import shutil
import subprocess


FIELDS = "uuid,name,utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw"


def number(value):
    try:
        result = float(value.strip())
    except ValueError:
        return None
    return result if math.isfinite(result) and result >= 0 else None


def parse_sample(output):
    gpus = []
    for row in csv.reader(io.StringIO(output), skipinitialspace=True):
        if not row:
            continue
        if len(row) != 7:
            raise ValueError("Unexpected NVIDIA telemetry format")
        identifier, name, usage, used, total, temperature, power = row
        gpus.append({
            "id": identifier.strip(),
            "name": name.strip(),
            "usage": number(usage),
            "memoryUsed": number(used),
            "memoryTotal": number(total),
            "temperature": number(temperature),
            "power": number(power),
        })
    return gpus


def unavailable(message):
    return {"available": False, "message": message, "gpus": []}


def collect(binary=None):
    binary = binary or shutil.which("nvidia-smi")
    if not binary:
        return unavailable("NVIDIA monitoring unavailable")
    try:
        result = subprocess.run(
            [binary, "--query-gpu=" + FIELDS, "--format=csv,noheader,nounits"],
            capture_output=True, text=True, timeout=3, check=False,
        )
    except subprocess.TimeoutExpired:
        return unavailable("NVIDIA monitoring timed out")
    except OSError:
        return unavailable("NVIDIA monitoring unavailable")
    if result.returncode:
        return unavailable("Driver unavailable")
    try:
        gpus = parse_sample(result.stdout)
    except ValueError:
        return unavailable("NVIDIA monitoring unavailable")
    if not gpus:
        return unavailable("No NVIDIA GPU detected")
    return {"available": True, "message": "", "gpus": gpus}


if __name__ == "__main__":
    print(json.dumps(collect(), allow_nan=False))
