import json
import logging
import os
from pathlib import Path

log_level_str = os.environ.get('LOG_LEVEL', 'INFO').upper()
log_level = getattr(logging, log_level_str, logging.INFO)
logging.basicConfig(level=log_level, format='%(asctime)s - %(levelname)s - %(message)s',
                    handlers=[logging.StreamHandler()])
logger = logging.getLogger(__name__)

STATE_FILE = Path('logical_clock.state')

def _load_clock():
    if not STATE_FILE.exists():
        return 0
    try:
        with open(STATE_FILE, 'r') as f:
            data = json.load(f)
            return data.get('clock', 0)
    except (IOError, json.JSONDecodeError, ValueError) as e:
        logger.error(f"Failed to load clock state: {e}")
        return None

def _save_clock(value):
    try:
        with open(STATE_FILE, 'w') as f:
            json.dump({'clock': value}, f, separators=(',', ':'))
        return True
    except IOError as e:
        logger.error(f"Failed to save clock state: {e}")
        return False

def current_time():
    clock = _load_clock()
    if clock is None:
        return {"error": "Failed to load clock state", "signal": "LOGICAL_CLOCK"}
    return {"logical_time": clock, "signal": "LOGICAL_CLOCK"}

def tick():
    clock = _load_clock()
    if clock is None:
        return {"error": "Failed to load clock state", "signal": "LOGICAL_CLOCK"}
    new_clock = clock + 1
    if not _save_clock(new_clock):
        return {"error": "Failed to save clock state", "signal": "LOGICAL_CLOCK"}
    return {"logical_time": new_clock, "signal": "LOGICAL_CLOCK"}
