#!/bin/bash
set -euo pipefail

mpiexec="mpiexec"
if [[ "$mpi" == "mpich" ]]; then
    export HYDRA_LAUNCHER=fork
elif [[ "$mpi" == "openmpi" ]]; then
    export OMPI_MCA_plm=isolated
    export OMPI_MCA_rmaps_base_oversubscribe=yes
    export OMPI_MCA_btl_vader_single_copy_mechanism=none
    export OMPI_MCA_coll_basic_priority=100
    mpiexec="mpiexec --allow-run-as-root"
fi

# pipe stdout, stderr through cat to avoid O_NONBLOCK issues
$mpiexec "$@" 2>&1 | cat
