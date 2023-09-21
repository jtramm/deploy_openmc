#!/bin/bash
CARD=0
TILE=0
LOCAL_RANK=${PALS_LOCAL_RANKID}

CARD=$(( $LOCAL_RANK / 8 ))
CARD_RANK=$(( $LOCAL_RANK - $CARD * 8))
TILE=$(( $CARD_RANK / 4 ))

export ZEX_NUMBER_OF_CCS=0:4

# Assign 8 MPI ranks for each card
export ZE_AFFINITY_MASK=${CARD}.${TILE}

#####################################################

## First 24 ranks will run on tile 0
#if [ $PALS_LOCAL_RANKID -lt 24 ]
#then
#	TILE=0
#else
#	TILE=1
#fi
#export ZEX_NUMBER_OF_CCS=0:4
#
#
## Assign 8 MPI ranks for each card
#CARD=$((LOCAL_RANK%6))
#export ZE_AFFINITY_MASK=${CARD}.${TILE}

#####################################################


# echo "Rank ID $LOCAL_RANK will run on GPU $CARD tile $TILE. ZE_AFFINITY_MASK = $ZE_AFFINITY_MASK. ZEX_NUMBER_OF_CCS = $ZEX_NUMBER_OF_CCS"

# Debugging Run
#if [ $PMIX_RANK -eq 623 ]
#then
	#LIBOMPTARGET_DEBUG=1 gdb-oneapi -ex=r --args openmc --event -s 1 -i 775000 -n ${1}
#	gdb-oneapi -ex=r --args openmc --event -s 1 -i 775000 -n ${1}
#else
#	openmc --event -s 1 -i 775000 -n ${1}
#fi
	
# Regular Run
openmc --event -s 2 -i 1000000 -n ${1} --no-sort-non-fissionable-xs --no-sort-surface-crossing --no-sort-device
#openmc --event -s 2 -i 1000000 -n ${1} --no-sort-non-fissionable-xs --no-sort-surface-crossing
#openmc --event -s 2 -i 1000000 -n ${1} --no-sort-non-fissionable-xs --no-sort-surface-crossing

# Device Profiling Run
#onetrace -d -v openmc --event -s 2 -i 775000 -n ${1} &> onetrace_${LOCAL_RANK}.txt

# Host API profiling Run
#onetrace -h openmc --event -s 2 -i 775000 -n ${1} &> host_onetrace_${LOCAL_RANK}.txt

# All Debug
#export FI_CXI_DEFAULT_CQ_SIZE=131072
#export FI_CXI_OVFLOW_BUF_SIZE=8388608
#export FI_CXI_CQ_FILL_PERCENT=20

#gdb-oneapi -ex=r --args openmc --event -s 1 -i 775000 -n ${1}
#gdb-oneapi -ex=r --args openmc -s 2 -i 775000 -n ${1}
#openmc -s 2 -i 775000 -n ${1}
