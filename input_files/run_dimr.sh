#!/bin/bash 

#SBATCH --job-name=LakeSeminole     # Job name 
#SBATCH --output=%x_%j.out          # Output file 
#SBATCH --error=%x_%j.err           # Error file 
#SBATCH --nodes=1                   # How many nodes to run on 
#SBATCH --ntasks=14                 # How many tasks
#SBATCH --cpus-per-task=3           # How many CPU per taks 
#SBATCH --mem=84g                   # Total memory: 48 cores total * 2GB/core
#SBATCH --partition=short           # Partition CPU node to run your job on
#SBATCH --time=10:00:00             # Time limit hrs:min:sec 
#SBATCH --mail-type=BEGIN,END,FAIL  # Which notifications to get
#SBATCH --mail-user=cortel@bc.edu   # Email to send notifications

set -e # stop after an error occurred:

export LD_PRELOAD="/lib64/libm.so.6:/lib64/librt.so.1:/lib64/libpthread.so.0:/lib64/libdl.so.2"

# Set DIMR path
dimrdir="/projects/snyderlab/Modules/delft3dfm" 

# DIMR input-file; must already exist!
dimrFile="dimr_config.xml"

DFM_LIB_PATH=$dimdir/lnx64/lib

if [ -n "$LD_LIBRARY_PATH" ]; then
    export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | tr ':' '\n' | \
                            grep -v "^$DFM_LIB_PATH$" | tr '\n' ':')
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH#:}
fi

# Use the values requested in the SBATCH header
# you can alternatively use SLURM_CPUS_ON_NODE/SLURM_NTASKS
nNodes=$SLURM_NNODES  # Set the total number of nodes
nProc=$SLURM_NTASKS   # Set the total number of tasks
nPart=$nProc          # Set the total number of partitions

# jobName: $FOLDERNAME
export jobName="${PWD##*/}"

# Replace number of processes in DIMR file (Logic from your script)
PROCESSSTR="$(seq -s " " 0 $((nPart-1)))"
# The 'sed' command replaces the content between <process>...</process> in dimrFile
sed -i "s/\(<process.*>\)[^<>]*\(<\/process.*\)/\1$PROCESSSTR\2/" $dimrFile

# Read MDU file from DIMR-file (Logic from your script)
mduFile="$(sed -n 's/\r//; s/<inputFile>\(.*\).mdu<\/inputFile>/\1/p' $dimrFile)".mdu

if [ "$nPart" -le "1" ]; then
    # Serial Run (nPart is 1 or less)
    echo "Starting SERIAL run on 1 core..."
    $dimrdir/lnx64/bin/run_dimr.sh -m $dimrFile
else
    # Parallel Run
    echo "Starting PARALLEL run with $nPart partitions..."

    # Step A: Partition the model (run_dflowfm.sh)
    echo "Partitioning model for $nPart domains..."
    cd dflowfm
    $dimrdir/lnx64/bin/run_dflowfm.sh --partition:ndomains=$nPart:icgsolver=6 $mduFile
    cd ..

    # Step B: Execute the parallel simulation (run_dimr.sh)
    echo "Executing parallel simulation via DIMR wrapper..."
    # The run_dimr.sh script likely contains the MPI launch (mpirun or mpiexec). 
    # For optimal performance on a SLURM system, ensure this wrapper either uses 'srun' internally 
    # or replace this line with a direct 'srun' call if the wrapper fails
    
    # Load Intel MPI
    module load intel-oneapi-mpi/2021.14.1

    # Force Delft3D-FM/MPI code to use the cores allocated by SLURM
    export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

    # Tell Intel MPI to use PMIx (more stable with SLURM)
    export I_MPI_PMI_LIBRARY=pmix

    # Tell Intel MPI to use shared memory (shm) since if the job is on 1 node
    # If running on multiple nodes we need to change the protocol or simply comment the following line
    export I_MPI_FABRICS=shm

    # Launch job using srun
    echo "Executing parallel simulation via srun (tasks=$nPart, binding=none)..."
    srun --ntasks=$nPart --cpu-bind=threads $dimrdir/lnx64/bin/dimr $dimrFile

fi

echo "Job finished."