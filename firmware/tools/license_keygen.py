#!/usr/bin/env python3
"""
license_keygen.py - activation code generator for the Tosee Noavaran Jonoub
vehicle traffic counter (dsPIC30F4011 + W25Q64JVS).

The device prints its flash unique id when it receives the serial command
"0198":

    UID: E4680C51A1B23344

Feed that value to this script; it returns the 8 hexadecimal characters that
the installer appends to the "0199" command:

    $ python3 license_keygen.py E4680C51A1B23344
    UID  E4680C51A1B23344
    KEY  9F3C21D0
    CMD  01999F3C21D0

The algorithm is the exact mirror of license_hash() in firmware/Main/License.h.
KEEP LIC_SECRET SECRET - anyone who has it can activate any board.
"""

import sys

# must match LIC_SECRET in firmware/Main/License.h
LIC_SECRET = 0x5A17C3E9
# must match XMICRO in firmware/Main/Variables.h
XMICRO = 4

M32 = 0xFFFFFFFF


def license_hash(uid: bytes) -> int:
    if len(uid) != 8:
        raise ValueError("the unique id is 8 bytes / 16 hex characters")
    h = LIC_SECRET
    for b in uid:
        h = (h ^ b) & M32
        h = (h * 16777619) & M32
        h = (h ^ (h >> 13)) & M32
    h = (h ^ XMICRO) & M32
    return h if h else LIC_SECRET


def main(argv):
    if len(argv) != 2:
        print(__doc__)
        return 1
    text = argv[1].strip().replace(" ", "").replace(":", "")
    if text.upper().startswith("UID"):
        text = text[3:].lstrip(" :")
    try:
        uid = bytes.fromhex(text)
    except ValueError:
        print("error: '%s' is not a hexadecimal unique id" % argv[1])
        return 1
    try:
        key = license_hash(uid)
    except ValueError as exc:
        print("error: %s" % exc)
        return 1
    print("UID  %s" % uid.hex().upper())
    print("KEY  %08X" % key)
    print("CMD  0199%08X" % key)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
