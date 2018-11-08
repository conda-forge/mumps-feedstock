###############################################################################
#    Try to compile MUMPS.
#
#   Record of revision:
#      Date        Programmer           Description of change
#    =========     ==========           =====================
#    Nov 2016        YUAN Xi                 Original
#    Nov 2017     Richard Otis         -DAdd_ for m2w64 support
#    Oct 2018     Joseph Weston     Enable builds for all supported precisions
#    Oct 2018     Joseph Weston     Modify for use with MUMPS 5.1.x
###############################################################################

cmake_minimum_required(VERSION 3.6.0)


###############################################################################
# Project name
###############################################################################
project(MUMPS Fortran C)

###############################################################################
# Options
###############################################################################
add_definitions(-DAdd_)


find_package(BLAS)
if(NOT BLAS_FOUND)
  message(FATAL_ERROR "BLAS not found")
endif()

# -DWITH_MPI
option(WITH_MPI "for parallel environment with MPI" OFF)
if(WITH_MPI)
  find_package(MPI REQUIRED)
  if(MPI_Fortran_FOUND AND MPI_CXX_FOUND AND MPI_C_FOUND)
    include_directories(${MPI_C_INCLUDE_PATH})
    set(CMAKE_C_LINK_FLAGS ${CMAKE_C_LINK_FLAGS} ${MPI_C_LINK_FLAGS})
    set(CMAKE_CXX_LINK_FLAGS ${CMAKE_CXX_LINK_FLAGS} ${MPI_CXX_LINK_FLAGS})
    set(CMAKE_Fortran_LINK_FLAGS ${CMAKE_Fortran_LINK_FLAGS} ${MPI_Fortran_LINK_FLAGS})
  else()
    set(WITH_MPI OFF)
  endif()
endif()

include_directories(
  ${MUMPS_SOURCE_DIR}/include
  ${MUMPS_SOURCE_DIR}/PORD/include
)

if(NOT WITH_MPI)
  include_directories(${MUMPS_SOURCE_DIR}/libseq)
endif()

set(COMMON_CSOURCES
src/mumps_common.c
src/mumps_pord.c
src/mumps_metis.c
src/mumps_metis64.c
src/mumps_metis_int.c
src/mumps_scotch.c
src/mumps_scotch64.c
src/mumps_scotch_int.c
src/mumps_size.c
src/mumps_io.c
src/mumps_io_basic.c
src/mumps_io_thread.c
src/mumps_io_err.c
src/mumps_numa.c
src/mumps_thread.c
src/mumps_save_restore_C.c
)

if(NOT WITH_MPI)
  set(COMMON_CSOURCES
  ${COMMON_CSOURCES}
  libseq/elapse.c
  libseq/mpic.c)
endif()

set(COMMON_FSOURCES
src/lr_common.F
src/ana_omp_m.F
src/ana_orderings_wrappers_m.F
src/mumps_memory_mod.F
src/mumps_static_mapping.F
src/mumps_sol_es.F
src/fac_future_niv2_mod.F
src/mumps_comm_ibcast.F
src/mumps_ooc_common.F
src/double_linked_list.F
src/fac_asm_build_sort_index_m.F
src/fac_asm_build_sort_index_ELT_m.F
src/omp_tps_common_m.F
src/mumps_l0_omp_m.F
src/front_data_mgt_m.F
src/fac_maprow_data_m.F
src/fac_descband_data_m.F
src/fac_ibct_data_m.F
src/ana_orderings.F
src/ana_AMDMF.F
src/bcast_errors.F
src/estim_flops.F
src/mumps_type_size.F
src/mumps_type2_blocking.F
src/mumps_version.F
src/tools_common.F
src/mumps_print_defined.F
src/ana_set_ordering.F
)

if(NOT WITH_MPI)
  set(COMMON_FSOURCES
  ${COMMON_FSOURCES}
  libseq/mpi.F)
endif()

set(CSOURCES
src/mumps_c.c
)

add_library(mumps_common STATIC ${COMMON_CSOURCES} ${COMMON_FSOURCES})

set(PORD_SOURCES
PORD/lib/graph.c
PORD/lib/gbipart.c
PORD/lib/gbisect.c
PORD/lib/ddcreate.c
PORD/lib/ddbisect.c
PORD/lib/nestdiss.c
PORD/lib/multisector.c
PORD/lib/gelim.c
PORD/lib/bucket.c
PORD/lib/tree.c
PORD/lib/symbfac.c
PORD/lib/interface.c
PORD/lib/sort.c
PORD/lib/minpriority.c
)
add_library(pord STATIC ${PORD_SOURCES})


foreach(ARCH s d c z)

set(FSOURCES
src/${ARCH}ana_aux_par.F
src/${ARCH}ana_lr.F
src/${ARCH}fac_asm_master_m.F
src/${ARCH}fac_asm_master_ELT_m.F
src/${ARCH}omp_tps_m.F
src/${ARCH}mumps_comm_buffer.F
src/${ARCH}mumps_load.F
src/${ARCH}mumps_lr_data_m.F
src/${ARCH}mumps_ooc_buffer.F
src/${ARCH}mumps_ooc.F
src/${ARCH}mumps_struc_def.F
src/${ARCH}static_ptr_m.F
src/${ARCH}lr_core.F
src/${ARCH}lr_type.F
src/${ARCH}lr_stats.F
src/${ARCH}fac_lr.F
src/${ARCH}fac_omp_m.F
src/${ARCH}fac_par_m.F
src/${ARCH}fac_front_LU_type1.F
src/${ARCH}fac_front_LU_type2.F
src/${ARCH}fac_front_LDLT_type1.F
src/${ARCH}fac_front_LDLT_type2.F
src/${ARCH}fac_front_aux.F
src/${ARCH}fac_front_type2_aux.F
src/${ARCH}mumps_save_restore_files.F
src/${ARCH}mumps_save_restore.F
src/${ARCH}ini_driver.F
src/${ARCH}ana_driver.F
src/${ARCH}fac_driver.F
src/${ARCH}sol_driver.F
src/${ARCH}end_driver.F
src/${ARCH}ana_aux_ELT.F
src/${ARCH}ana_aux.F
src/${ARCH}ana_dist_m.F
src/${ARCH}ana_LDLT_preprocess.F
src/${ARCH}ana_reordertree.F
src/${ARCH}arrowheads.F
src/${ARCH}bcast_int.F
src/${ARCH}fac_asm_ELT.F
src/${ARCH}fac_asm.F
src/${ARCH}fac_b.F
src/${ARCH}fac_distrib_distentry.F
src/${ARCH}fac_distrib_ELT.F
src/${ARCH}fac_lastrtnelind.F
src/${ARCH}fac_mem_alloc_cb.F
src/${ARCH}fac_mem_compress_cb.F
src/${ARCH}fac_mem_free_block_cb.F
src/${ARCH}fac_mem_stack_aux.F
src/${ARCH}fac_mem_stack.F
src/${ARCH}fac_process_band.F
src/${ARCH}fac_process_blfac_slave.F
src/${ARCH}fac_process_blocfacto_LDLT.F
src/${ARCH}fac_process_blocfacto.F
src/${ARCH}fac_process_bf.F
src/${ARCH}fac_process_end_facto_slave.F
src/${ARCH}fac_process_contrib_type1.F
src/${ARCH}fac_process_contrib_type2.F
src/${ARCH}fac_process_contrib_type3.F
src/${ARCH}fac_process_maprow.F
src/${ARCH}fac_process_master2.F
src/${ARCH}fac_process_message.F
src/${ARCH}fac_process_root2slave.F
src/${ARCH}fac_process_root2son.F
src/${ARCH}fac_process_rtnelind.F
src/${ARCH}fac_root_parallel.F
src/${ARCH}fac_scalings.F
src/${ARCH}fac_determinant.F
src/${ARCH}fac_scalings_simScaleAbs.F
src/${ARCH}fac_scalings_simScale_util.F
src/${ARCH}fac_sol_pool.F
src/${ARCH}fac_type3_symmetrize.F
src/${ARCH}ini_defaults.F
src/${ARCH}mumps_driver.F
src/${ARCH}mumps_f77.F
src/${ARCH}mumps_iXamax.F
src/${ARCH}ana_mtrans.F
src/${ARCH}ooc_panel_piv.F
src/${ARCH}rank_revealing.F
src/${ARCH}sol_aux.F
src/${ARCH}sol_bwd_aux.F
src/${ARCH}sol_bwd.F
src/${ARCH}sol_c.F
src/${ARCH}sol_fwd_aux.F
src/${ARCH}sol_fwd.F
src/${ARCH}sol_matvec.F
src/${ARCH}sol_root_parallel.F
src/${ARCH}tools.F
src/${ARCH}type3_root.F
)


set(ARCHLIB ${ARCH}mumps)
set(EXAMPLE
examples/${ARCH}simpletest.F
)

add_library(${ARCHLIB} SHARED ${CSOURCES} ${FSOURCES})
target_compile_definitions(${ARCHLIB} PUBLIC MUMPS_ARITH=MUMPS_ARITH_${ARCH} )
add_executable(${ARCH}simpletest ${EXAMPLE})
target_link_libraries(${ARCHLIB} mumps_common pord ${BLAS_LIBRARIES})
target_link_libraries(${ARCH}simpletest ${ARCHLIB} mumps_common pord ${BLAS_LIBRARIES})
install(TARGETS ${ARCHLIB} DESTINATION bin)
install(FILES include/${ARCH}mumps_struc.h include/${ARCH}mumps_root.h include/${ARCH}mumps_c.h DESTINATION include)

endforeach(ARCH)

install(TARGETS mumps_common pord DESTINATION lib)
install(FILES include/mumps_c_types.h include/mumps_compat.h DESTINATION include)
