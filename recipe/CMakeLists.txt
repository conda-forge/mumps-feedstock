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


find_package(BLAS)
if(NOT BLAS_FOUND)
  message(FATAL_ERROR "BLAS not found")
endif()

find_package(LAPACK)
if(NOT LAPACK_FOUND)
  message(FATAL_ERROR "LAPACK not found")
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
  ${MUMPS_SOURCE_DIR}/src
  ${MUMPS_SOURCE_DIR}/PORD/include
)

if(NOT WITH_MPI)
  include_directories(${MUMPS_SOURCE_DIR}/libseq)
endif()

# update sources on each release
# order and section shall match Makefile in MUMPS source

# OBJS_COMMON_MOD
set(
  COMMON_MOD
  src/ana_omp_m.F
  src/ana_orderings_wrappers_m.F
  src/double_linked_list.F
  src/fac_asm_build_sort_index_m.F
  src/fac_asm_build_sort_index_ELT_m.F
  src/fac_descband_data_m.F
  src/fac_future_niv2_mod.F
  src/fac_ibct_data_m.F
  src/fac_maprow_data_m.F
  src/front_data_mgt_m.F
  src/lr_common.F
  src/mumps_comm_ibcast.F
  src/mumps_l0_omp_m.F
  src/mumps_memory_mod.F
  src/mumps_ooc_common.F
  src/mumps_static_mapping.F
  src/omp_tps_common_m.F
)

# OBJS_COMMON_OTHER
set(
  COMMON_OTHER
  src/ana_orderings.F
  src/ana_set_ordering.F
  src/ana_AMDMF.F
  src/bcast_errors.F
  src/estim_flops.F
  src/mumps_type_size.F
  src/mumps_type2_blocking.F
  src/mumps_version.F
  src/mumps_print_defined.F
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
  src/mumps_config_file_C.c
  src/mumps_thread_affinity.c
  src/tools_common.F
  src/sol_common.F
)

if(NOT WITH_MPI)
  set(COMMON_OTHER
    ${COMMON_OTHER}
    libseq/elapse.c
    libseq/mpic.c
    libseq/mpi.F
  )
endif()

add_library(mumps_common STATIC ${COMMON_MOD} ${COMMON_OTHER})
target_compile_definitions(mumps_common PRIVATE -DAdd_)
# Hack to fix incorrect assumption that Windows=gfortran
target_compile_definitions(mumps_common PRIVATE -DMUMPS_CALL=__declspec\(dllexport\))
target_compile_definitions(mumps_common PRIVATE -DLIBSEQ_CALL=__declspec\(dllexport\))

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


foreach(ARITH s d c z)

# OBJS_MOD
set(
  ARITH_MOD
  src/${ARITH}ana_aux.F
  src/${ARITH}ana_aux_par.F
  src/${ARITH}ana_lr.F
  src/${ARITH}fac_asm_master_ELT_m.F
  src/${ARITH}fac_asm_master_m.F
  src/${ARITH}fac_front_aux.F
  src/${ARITH}fac_front_LU_type1.F
  src/${ARITH}fac_front_LU_type2.F
  src/${ARITH}fac_front_LDLT_type1.F
  src/${ARITH}fac_front_LDLT_type2.F
  src/${ARITH}fac_front_type2_aux.F
  src/${ARITH}fac_lr.F
  src/${ARITH}fac_mem_dynamic.F
  src/${ARITH}fac_omp_m.F
  src/${ARITH}fac_par_m.F
  src/${ARITH}lr_core.F
  src/${ARITH}lr_stats.F
  src/${ARITH}lr_type.F
  src/${ARITH}mumps_comm_buffer.F
  src/${ARITH}mumps_config_file.F
  src/${ARITH}mumps_load.F
  src/${ARITH}mumps_lr_data_m.F
  src/${ARITH}mumps_ooc_buffer.F
  src/${ARITH}mumps_ooc.F
  src/${ARITH}mumps_sol_es.F
  src/${ARITH}mumps_save_restore.F
  src/${ARITH}mumps_save_restore_files.F
  src/${ARITH}mumps_struc_def.F
  src/${ARITH}omp_tps_m.F
  src/${ARITH}sol_lr.F
  src/${ARITH}static_ptr_m.F
)

# OBJS_OTHER
set(
  ARITH_OTHER
  src/${ARITH}ini_driver.F
  src/${ARITH}ana_driver.F
  src/${ARITH}fac_driver.F
  src/${ARITH}sol_driver.F
  src/${ARITH}sol_distrhs.F
  src/${ARITH}end_driver.F
  src/${ARITH}ana_aux_ELT.F
  src/${ARITH}ana_dist_m.F
  src/${ARITH}ana_LDLT_preprocess.F
  src/${ARITH}ana_reordertree.F
  src/${ARITH}arrowheads.F
  src/${ARITH}bcast_int.F
  src/${ARITH}fac_asm_ELT.F
  src/${ARITH}fac_asm.F
  src/${ARITH}fac_b.F
  src/${ARITH}fac_distrib_distentry.F
  src/${ARITH}fac_distrib_ELT.F
  src/${ARITH}fac_lastrtnelind.F
  src/${ARITH}fac_mem_alloc_cb.F
  src/${ARITH}fac_mem_compress_cb.F
  src/${ARITH}fac_mem_free_block_cb.F
  src/${ARITH}fac_mem_stack_aux.F
  src/${ARITH}fac_mem_stack.F
  src/${ARITH}fac_process_band.F
  src/${ARITH}fac_process_blfac_slave.F
  src/${ARITH}fac_process_blocfacto_LDLT.F
  src/${ARITH}fac_process_blocfacto.F
  src/${ARITH}fac_process_bf.F
  src/${ARITH}fac_process_end_facto_slave.F
  src/${ARITH}fac_process_contrib_type1.F
  src/${ARITH}fac_process_contrib_type2.F
  src/${ARITH}fac_process_contrib_type3.F
  src/${ARITH}fac_process_maprow.F
  src/${ARITH}fac_process_master2.F
  src/${ARITH}fac_process_message.F
  src/${ARITH}fac_process_root2slave.F
  src/${ARITH}fac_process_root2son.F
  src/${ARITH}fac_process_rtnelind.F
  src/${ARITH}fac_root_parallel.F
  src/${ARITH}fac_scalings.F
  src/${ARITH}fac_determinant.F
  src/${ARITH}fac_scalings_simScaleAbs.F
  src/${ARITH}fac_scalings_simScale_util.F
  src/${ARITH}fac_sol_pool.F
  src/${ARITH}fac_type3_symmetrize.F
  src/${ARITH}ini_defaults.F
  src/mumps_c.c
  src/${ARITH}mumps_driver.F
  src/${ARITH}mumps_f77.F
  src/${ARITH}mumps_gpu.c
  src/${ARITH}mumps_iXamax.F
  src/${ARITH}ana_mtrans.F
  src/${ARITH}ooc_panel_piv.F
  src/${ARITH}rank_revealing.F
  src/${ARITH}sol_aux.F
  src/${ARITH}sol_bwd_aux.F
  src/${ARITH}sol_bwd.F
  src/${ARITH}sol_c.F
  src/${ARITH}sol_fwd_aux.F
  src/${ARITH}sol_fwd.F
  src/${ARITH}sol_matvec.F
  src/${ARITH}sol_root_parallel.F
  src/${ARITH}tools.F
  src/${ARITH}type3_root.F
)

set(ARITHLIB ${ARITH}mumps)
set(EXAMPLE examples/${ARITH}simpletest.F)

add_library(${ARITHLIB} SHARED ${ARITH_MOD} ${ARITH_OTHER})
set_target_properties(${ARITHLIB} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
target_compile_definitions(${ARITHLIB} PUBLIC MUMPS_ARITH=MUMPS_ARITH_${ARITH})
# Hack to fix incorrect assumption that Windows=gfortran
target_compile_definitions(${ARITHLIB} PRIVATE -DAdd_)
target_compile_definitions(${ARITHLIB} PRIVATE -DMUMPS_CALL=__declspec\(dllexport\))
add_executable(${ARITH}simpletest ${EXAMPLE})
target_link_libraries(${ARITHLIB} mumps_common pord ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
target_link_libraries(${ARITH}simpletest ${ARITHLIB} mumps_common pord ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
install(TARGETS ${ARITHLIB} DESTINATION bin)
install(FILES include/${ARITH}mumps_struc.h include/${ARITH}mumps_root.h include/${ARITH}mumps_c.h DESTINATION include)

endforeach(ARITH)
set(EXAMPLE examples/c_example.c)
add_executable(c_example ${EXAMPLE})
target_link_libraries(c_example dmumps mumps_common pord ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
install(TARGETS mumps_common pord DESTINATION lib)
install(FILES include/mumps_c_types.h include/mumps_compat.h DESTINATION include)
if(NOT WITH_MPI)
  install(FILES libseq/mpif.h DESTINATION include/mumps_seq)
  install(FILES libseq/mpi.h DESTINATION include/mumps_seq)
endif()
