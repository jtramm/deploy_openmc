# openmc_deployment

## Overview (What these scripts do)

The purpose of these scripts is to automatically download/install/module-ize OpenMC. The downloading and compiling stages are fairly straightforward and would not warrant the creation of these scripts, but the key capability of this project is the "module-ize" idea. By doing some minor configurations and then running these scripts, you can generate a set of modules, e.g., (`openmc/2023.09.25.0`, `openmc/2023.10.03.0`, and `openmc/2023.10.03.1`) and corresponding binary installs. The benefit of this is that you don't need to overwrite older (working versions) of your code + compiler environment. Rather, you can have easy access to historical versions that perhaps used older compiler and OpenMC versions, but may be faster/more reliable than the newest build.

The script is also capable of automatically generating version numbers, such that muliple can be generated in a day. One potential use case of these scripts is to be scheduled as an e.g. weekly cron job, such that the newest versions of OpenMC are always available on multiple clusters automatically. Specifically, it would be nice to maintain installs on Crusher/Frontier/Sunspot/Aurora, along with any other systems. Potentially, a lighter-weight testing script can also be scheduled with cron to run weekly on all these machines and report results via email, such that our CI can expand to a wider scale and run on end-user machines.

A tricky component of these scripts is that both specific modulefile versions and specific OpenMC binary install versions need to be maintained, and the versioned modulefiles need to point to the versioned binary install locations. Additionally, the versioned modulefiles are designed not just to load OpenMC by itself into the environment, but to also load in all of its dependencies. This is a key point, as we want the module to be stable over time, and not have it use module defaults which shift as new compiler versions are installed on the system.

## Setup & Configuration

The general way to use these scrips is to follow the below steps. The first few steps instruct you on how to configure the scripts, and then later steps instruct on how to actually run the scripts and then make use of the new module.

1. The first thing you'll need to do is setup your compiler environment. This can be done via editing (or better yet, copying then editing) one of the example modulefiles in `modulefiles/template_modulefiles`. e.g.,:

```
cd modulefiles/template_modulefiles
cp frontier my_frontier
# (edit my_frontier file)
```

Once your compiler is setup for that system in your new modulefile (e.g., you have loaded all compiler, hdf5, and cmake modules needed for OpenMC) in the file, you can proceed to the next step. Several templates are provided for various real systems (e.g., `aurora`, `frontier`, `generic_a100`, `generic_mi250`), though I do not guarantee that all those modules are still working and/or even available. It is best to copy these templates to a new modulefile and edit them.

Note that this file contains two macros (`DEPLOY_OPENMC_HOME` and `DEPLOY_OPENMC_VID`) that will be set automatically by the scripts when the module is versioned, so please leave these in place.

2. Edit the `1_create_module.sh` script to point to the location of your new module file. You'll need to edit `export BASE_MODULE=generic_a100` to point to whatever the neame of your new module file is. Following the above example, you would open `1_create_module.sh` and set:

```
BASE_MODULE=my_frontier
```

Note that your new modulefile is expected to be located in the `modulefiles/template_modulefiles` directory.

3. Now you'll need to setup your compile script. This can be done by editing the `3_compile.sh` file. While you should have already loaded any needed modules or set any environment variables in Step 1, in `3_compile.sh` you can edit what specific options you want to pass to cmake. In particular, you may wish to change what sort of on-device sorting library is used (by default, it is configured to use the NVIDIA CUDA thrust sorting library, so if using AMD or Intel, you'll definitely want to make edits. You can also add in debugging flags to the cmake line.  

4. Download Inputs (optional). If you are installing for the first time, this step is recommended so that OpenMC's data files are located in the expected location, and that all source code has been downloaded. This step will involve cloning several github repositories in .ssh mode, so your github credentials may need to be up to date.

```
./0_download.sh
```

Note that you can also execute each step individually by running the `download.sh` files in the data, benchmarks, and code directories.

5. With your custom modulefile, `1_create_module.sh`, and  `3_compile.sh` scripts configured and ready, you are now ready to run the scripts:

```
source ./1_create_module.sh # Generates a new version ID,  sets env variables
source ./2_deploy_module.sh # Copies and converts base module file to versioned modulefile
./3_compile.sh # Compiles OpenMC
./4_deploy_install.sh # Installs OpenMC binary/library files to a versioned folder
```

6. Once on a compute node, or when ready to run the code, you can load in the specific module you just created with:

```
source ./5_load_modulefiles.sh
module load openmc/YYYY.MM.DD.V
```

## Notes on Creating Subsequent Modules

- The script is setup to be run again without modification to generate new versions, without overwriting old installs.

- For example, you run the scripts and make a new versioned module in the morning. It will have a name like openmc/2023.09.07.0 You develop a new branch of the code with some optimizations, so want to generate a new module and compare it to the old one. You can simply go into the code/openmc folder and checkout the new branch, then navigate back up to the main directory and run all the scripts again (assuming you don't want to make any changes to compiler settings or environment settings) as:

```
source ./1_create_module.sh
source ./2_deploy_module.sh
./3_compile.sh
./4_deploy_install.sh
```

This new module will have a name like openmc/2023.09.07.1, and you can easily load/unload to switch betwen the two modules as desired.

- Scenario: You are trying to compile on Frontier, and copy the "frontier" base module file to "my_frontier" and set it to use a specific compiler. You follow the steps, but found that OpenMC fails to compile. In this case, you can edit the "my_frontier" base file to use a different compiler or set of modules, and then begin running through the steps again starting with source "./1_create_module.sh". In this scenario, a new module version ID will NOT be generated, rather, the original ID files will be overwritten. This is by design, as the scripts will not generate a new version ID until "./4_deploy_install.sh" is run which actually creates a versioned file in the installs directory (which governs the version ID generation). However, a new version will be generated if time goes by and the date command returns a subsequent day.

- Scenario: You are trying to compile on Frontier, and copy the "frontier" base module file to "my_frontier" and set it to use a specific compiler. You follow the steps, and OpenMC compiles successfully, but then crashes when running. In this case, you can edit the "my_frontier" base file to use a different compiler or set of modules, and then begin running through the steps again starting with source "./1_create_module.sh". In this scenario, a new module version ID WILL be generated.

- To delete a module, you would just need to delete it's folders: installs/YYYY.MM.DD.V and modulefiles/deployed_modulefiles/openmc/YYYY.MM.DD.V. However, be warned that the version ID generation script operates by detecting how many folders are there with the same YYYY.MM.DD tag, so may potentially overwrite a module if e.g., there are 3 modules for a given day and you delete the 2nd module, then try to generate a new one. This is not a problem though if you are generating a new module for a different day.
