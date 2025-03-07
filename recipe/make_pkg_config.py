import os
from pathlib import Path

tpl = """\
prefix={PREFIX}
exec_prefix=${{prefix}}
libdir=${{prefix}}/lib
sharedlibdir=${{libdir}}
includedir=${{prefix}}/include

Name: {NAME}
Description: {DESCRIPTION}
Version: {VERSION}
Cflags: -I${{includedir}}{extra_cflags}
Libs: -L${{libdir}} -l{NAME}
"""

prefix = Path(os.environ["PREFIX"])
version = os.environ["PKG_VERSION"]

lib = prefix / "lib"
pkgconfig_dir = lib / "pkgconfig"
pkgconfig_dir.mkdir(parents=True, exist_ok=True)


precision_desc = {
    "s": "single",
    "d": "double",
    "c": "complex single",
    "z": "complex double",

}
description_tpl = "The {parallel} {precision}-precision MUMPS library"

def render_one(name, description, extra_cflags):
    pc_file = pkgconfig_dir / (name + ".pc")
    print(f"Writing {pc_file}")
    pc_content = tpl.format(
        PREFIX=str(prefix),
        NAME=name,
        VERSION=version,
        DESCRIPTION=description,
        extra_cflags=extra_cflags,
    )
    print(pc_content)
    with pc_file.open("w") as f:
        f.write(pc_content)

if os.environ["mpi"] == "nompi":
    suffix = "_seq"
    parallel = "sequential"
    extra_cflags = " -I${includedir}/mumps_seq"
else:
    suffix = ""
    parallel = "parallel"
    extra_cflags = ""

for precision in ("s", "d", "c", "z"):
    name = f"{precision}mumps{suffix}"
    description = description_tpl.format(
        parallel=parallel,
        precision=precision_desc[precision],
    )
    render_one(name, description, extra_cflags)
