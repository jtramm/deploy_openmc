#!/bin/bash
# -l select=1:system=aurora,place=scatter
#PBS -l select=1
#PBS -A Aurora_deployment
#PBS -q workq
# -q debug
#PBS -l walltime=00:60:00
#PBS -N openmc_scaling
#PBS -l filesystems=home

export OMP_TARGET_OFFLOAD=MANDATORY
export IGC_ForceOCLSIMDWidth=16  # Does appear to have a minor affect (about 3%) on 1 rank/tile
#export LIBOMPTARGET_LEVEL_ZERO_COMMAND_BATCH=compute # Seems super slow without this one for some reason
unset LIBOMPTARGET_LEVEL_ZERO_COMMAND_BATCH
export LIBOMPTARGET_LEVEL_ZERO_USE_IMMEDIATE_COMMAND_LIST=1
export CFESingleSliceDispatchCCSMode=1 
export LIBOMPTARGET_DEVICES=SUBSUBDEVICE 

export TZ='/usr/share/zoneinfo/US/Central'
export OMP_PROC_BIND=spread
#export OMP_NUM_THREADS=1
unset OMP_PLACES

module use /home/jtramm/deploy_openmc/modulefiles/deployed_modulefiles
module load openmc/2023.09.21.0
cd /home/jtramm/deploy_openmc/benchmarks/core-fom-depleted

ulimit -c 0

#echo Jobid: $PBS_JOBID
#echo Running on host `hostname`
#echo Running on nodes `cat $PBS_NODEFILE`

NNODES=`wc -l < $PBS_NODEFILE`
NRANKS=48          # Number of MPI ranks per node
#NRANKS=1          # Number of MPI ranks per node
#NRANKS=8          # Number of MPI ranks per node
NDEPTH=1          # Number of hardware threads per rank, spacing between MPI ranks on a node
NTHREADS=$OMP_NUM_THREADS # Number of OMP threads per rank, given to OMP_NUM_THREADS

NTOTRANKS=$(( NNODES * NRANKS ))

#echo "NUM_NODES=${NNODES}  TOTAL_RANKS=${NTOTRANKS}  RANKS_PER_NODE=${NRANKS}  THREADS_PER_RANK=${OMP_NUM_THREADS}"
#echo "OMP_PROC_BIND=$OMP_PROC_BIND OMP_PLACES=$OMP_PLACES"

# Note: 2.5M/rank is the good value, but lets chop it for speed
# 625 was good, but still gave 0 output for larger runs
#NPARTICLES=$(( $NTOTRANKS * 10000000 ))
#NPARTICLES=$(( $NTOTRANKS * 5000000 ))
NPARTICLES=$(( $NTOTRANKS * 2500000 ))
#NPARTICLES=$(( $NTOTRANKS * 1250000 ))
#NPARTICLES=$(( $NTOTRANKS * 1000000 ))
#NPARTICLES=$(( $NTOTRANKS * 625000 ))
#NPARTICLES=$(( $NTOTRANKS * 312500 ))
#NPARTICLES=$(( $NTOTRANKS * 156250 ))
#NPARTICLES=$(( $NTOTRANKS * 20000000 ))

#mpiexec -np ${NTOTRANKS} -ppn ${NRANKS} -d ${NDEPTH} --cpu-bind depth -envall /home/jtramm/core-fom-depleted/scaling_launch.sh ${NPARTICLES}
mpiexec -np ${NTOTRANKS} -ppn ${NRANKS} -d ${NDEPTH} --cpu-bind=verbose,list:2:3:4:5:6:7:8:9:10:11:12:13:14:15:16:17:18:19:20:21:22:23:24:25:57:58:59:60:61:62:63:64:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80 -envall /home/jtramm/deploy_openmc/benchmarks/core-fom-depleted/sunspot_launcher.sh ${NPARTICLES}
