#!/bin/bash

#
#-----------------------------------------------------------------------
#
# This script copies files from various directories (e.g. fixed files 
# from a system directory, grid and orography files from the experi-
# ment's work directory, and template files from the templates direct-
# ory) into the experiment directory.  It then modifies some of these
# files to customize them for the current experiment setup.  It also 
# creates links in the experiment directory to some of these files with
# names that the SAR-FV3 model expects to read in.
#
#-----------------------------------------------------------------------
#

#
#-----------------------------------------------------------------------
#
# Source the variable definitions script and the function definitions
# file.
#
#-----------------------------------------------------------------------
#
. $SCRIPT_VAR_DEFNS_FP
. $USHDIR/source_funcs.sh
#
#-----------------------------------------------------------------------
#
# Save current shell options (in a global array).  Then set new options
# for this script/function.
#
#-----------------------------------------------------------------------
#
{ save_shell_opts; set -u -x; } > /dev/null 2>&1
#
#-----------------------------------------------------------------------
#
# Set the script name and print out an informational message informing
# the user that we've entered this script.
#
#-----------------------------------------------------------------------
#
script_name=$( basename "$0" )
print_info_msg "\n\
========================================================================
Entering script:  \"${script_name}\"
This script stages static files and creates links to static files, all
in the main experiment directory.
========================================================================"
#
#-----------------------------------------------------------------------
#
# Create the INPUT subdirectory under the experiment directory (EXPT-
# DIR).  This will contain static (i.e. cycle-independent) files that
# various files in the run directories (which are subdirectories of the
# experiment directory) will point to.  Note that the workflow genera-
# tion script creates the experiment directory, so we do not need to
# create it here.
#
#-----------------------------------------------------------------------
#
check_for_preexist_dir $EXPTDIR/INPUT $preexisting_dir_method
mkdir_vrfy "$EXPTDIR/INPUT"
#
#-----------------------------------------------------------------------
#
# Create the directory in which to place the results of the initial and
# boundary condition tasks.  
#
#-----------------------------------------------------------------------
#
check_for_preexist_dir $WORKDIR_ICSLBCS $preexisting_dir_method
mkdir_vrfy -p "$WORKDIR_ICSLBCS"
#
#-----------------------------------------------------------------------
#
# Copy fixed files from system directory to experiment directory.  Note
# that some of these files get renamed.
#
#-----------------------------------------------------------------------
#
print_info_msg_verbose "\
Copying fixed files from system directory to the experiment directory..."

cp_vrfy $FIXgsm/CFSR.SEAICE.1982.2012.monthly.clim.grb          $EXPTDIR
cp_vrfy $FIXgsm/RTGSST.1982.2012.monthly.clim.grb               $EXPTDIR
cp_vrfy $FIXgsm/seaice_newland.grb                              $EXPTDIR
cp_vrfy $FIXgsm/global_climaeropac_global.txt                   $EXPTDIR/aerosol.dat
cp_vrfy $FIXgsm/global_albedo4.1x1.grb                          $EXPTDIR
cp_vrfy $FIXgsm/global_glacier.2x2.grb                          $EXPTDIR
cp_vrfy $FIXgsm/global_h2o_pltc.f77                             $EXPTDIR/global_h2oprdlos.f77
cp_vrfy $FIXgsm/global_maxice.2x2.grb                           $EXPTDIR
cp_vrfy $FIXgsm/global_mxsnoalb.uariz.t126.384.190.rg.grb       $EXPTDIR
cp_vrfy $FIXgsm/global_shdmax.0.144x0.144.grb                   $EXPTDIR
cp_vrfy $FIXgsm/global_shdmin.0.144x0.144.grb                   $EXPTDIR
cp_vrfy $FIXgsm/global_slope.1x1.grb                            $EXPTDIR
cp_vrfy $FIXgsm/global_snoclim.1.875.grb                        $EXPTDIR
cp_vrfy $FIXgsm/global_snowfree_albedo.bosu.t126.384.190.rg.grb $EXPTDIR
cp_vrfy $FIXgsm/global_soilmgldas.t126.384.190.grb              $EXPTDIR
cp_vrfy $FIXgsm/global_soiltype.statsgo.t126.384.190.rg.grb     $EXPTDIR
cp_vrfy $FIXgsm/global_tg3clim.2.6x1.5.grb                      $EXPTDIR
cp_vrfy $FIXgsm/global_vegfrac.0.144.decpercent.grb             $EXPTDIR
cp_vrfy $FIXgsm/global_vegtype.igbp.t126.384.190.rg.grb         $EXPTDIR
cp_vrfy $FIXgsm/global_zorclim.1x1.grb                          $EXPTDIR
cp_vrfy $FIXgsm/global_sfc_emissivity_idx.txt                   $EXPTDIR/sfc_emissivity_idx.txt
cp_vrfy $FIXgsm/global_solarconstant_noaa_an.txt                $EXPTDIR/solarconstant_noaa_an.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2010.txt  $EXPTDIR/co2historicaldata_2010.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2011.txt  $EXPTDIR/co2historicaldata_2011.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2012.txt  $EXPTDIR/co2historicaldata_2012.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2013.txt  $EXPTDIR/co2historicaldata_2013.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2014.txt  $EXPTDIR/co2historicaldata_2014.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2015.txt  $EXPTDIR/co2historicaldata_2015.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2016.txt  $EXPTDIR/co2historicaldata_2016.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2017.txt  $EXPTDIR/co2historicaldata_2017.txt
cp_vrfy $FIXgsm/fix_co2_proj/global_co2historicaldata_2018.txt  $EXPTDIR/co2historicaldata_2018.txt
cp_vrfy $FIXgsm/global_co2historicaldata_glob.txt               $EXPTDIR/co2historicaldata_glob.txt
cp_vrfy $FIXgsm/co2monthlycyc.txt                               $EXPTDIR
#
# Why is file ozprdlos_2015_new_sbuvO3_tclm15_nuchem.f77 not in FIXgsm
# directory?
#cp_vrfy $FIXgsm/global_o3prdlos.f77                             $EXPTDIR
cp_vrfy /scratch4/NCEPDEV/nems/noscrub/emc.nemspara/RT/NEMSfv3gfs/trunk-20190424/FV3_input_data/ozprdlos_2015_new_sbuvO3_tclm15_nuchem.f77 $EXPTDIR/global_o3prdlos.f77

#
#-----------------------------------------------------------------------
#
# Copy templates of various input files to the experiment directory.
#
#-----------------------------------------------------------------------
#
print_info_msg_verbose "\
Copying templates of various input files to the experiment directory..."

if [ "$CCPP" = "true" ]; then
#
# Copy the shell script that initializes the Lmod (Lua-based module) 
# system/software for handling modules.  This script:
#
# 1) Detects the shell in which it is being invoked (i.e. the shell of
#    the "parent" script in which it is being sourced).
# 2) Detects the machine it is running on and and calls the appropriate 
#    (shell- and machine-dependent) initalization script to initialize 
#    Lmod.
# 3) Purges all modules.
# 4) Uses the "module use ..." command to prepend or append paths to 
#    Lmod's search path (MODULEPATH).
#
  print_info_msg_verbose "\
Copying the shell script that initializes the Lmod (Lua-based module) 
system/software for handling modules..."
#
# The following might have to be made shell-dependent, e.g. if using csh 
# or tcsh, copy over the file module-setup.csh.inc??.
#
# It may be convenient to also copy over this script when running the 
# non-CCPP version of the FV3SAR and try to simplify the run script 
# (run_FV3SAR.sh) so that it doesn't depend on whether CCPP is set to
# "true" or "false".  We can do that, but currently the non-CCPP and 
# CCPP-enabled versions of the FV3SAR code use different versions of
# intel and impi, so module-setup.sh must account for this.
#
  cp_vrfy $NEMSfv3gfs_DIR/NEMS/src/conf/module-setup.sh.inc $EXPTDIR/module-setup.sh
#
# Append the command that adds the path to the CCPP libraries (via the
# shell variable LD_LIBRARY_PATH) to the Lmod initialization script in 
# the experiment directory.  This is needed if running the dynamic build
# of the CCPP-enabled version of the FV3SAR.
#
  { cat << EOM >> $EXPTDIR/module-setup.sh
#
# Add path to libccpp.so and libccpphys.so to LD_LIBRARY_PATH"
#
export LD_LIBRARY_PATH="${NEMSfv3gfs_DIR}/ccpp/lib\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
EOM
} || print_err_msg_exit "${script_name}" "\
Heredoc (cat) command to append command to add path to CCPP libraries to
the Lmod initialization script in the experiment directory returned with
a nonzero status."

  if [ "$CCPP_phys_suite" = "GFS" ]; then

    cp_vrfy $TEMPLATE_DIR/$FV3_NML_CCPP_GFS_FN $EXPTDIR/$FV3_NML_FN
    cp_vrfy $TEMPLATE_DIR/$FIELD_TABLE_FN $EXPTDIR

  elif [ "$CCPP_phys_suite" = "GSD" ]; then

    cp_vrfy $TEMPLATE_DIR/$FV3_NML_CCPP_GSD_FN $EXPTDIR/$FV3_NML_FN
    cp_vrfy $TEMPLATE_DIR/$FIELD_TABLE_CCPP_GSD_FN $EXPTDIR/$FIELD_TABLE_FN

  fi

elif [ "$CCPP" = "false" ]; then

  cp_vrfy $TEMPLATE_DIR/$FV3_NML_FN $EXPTDIR
  cp_vrfy $TEMPLATE_DIR/$FIELD_TABLE_FN $EXPTDIR

fi

cp_vrfy $TEMPLATE_DIR/$DATA_TABLE_FN $EXPTDIR
cp_vrfy $TEMPLATE_DIR/$NEMS_CONFIG_FN $EXPTDIR
#
#-----------------------------------------------------------------------
#
# Set the full path to the FV3SAR namelist file.  Then set parameters in
# that file.
#
#-----------------------------------------------------------------------
#
FV3_NML_FP="$EXPTDIR/$FV3_NML_FN"

print_info_msg_verbose "\
Setting parameters in file:
  FV3_NML_FP = \"$FV3_NML_FP\""
#
# Set npx_T7 and npy_T7, which are just nx_T7 plus 1 and ny_T7 plus 1,
# respectively.  These need to be set in the FV3SAR Fortran namelist
# file.  They represent the number of cell vertices in the x and y di-
# rections on the regional grid (tile 7).
#
npx_T7=$(($nx_T7+1))
npy_T7=$(($ny_T7+1))
#
# Set parameters.
#
set_file_param "$FV3_NML_FP" "blocksize" "$blocksize"
set_file_param "$FV3_NML_FP" "layout" "$layout_x,$layout_y"
set_file_param "$FV3_NML_FP" "npx" "$npx_T7"
set_file_param "$FV3_NML_FP" "npy" "$npy_T7"

if [ "$grid_gen_method" = "GFDLgrid" ]; then
# Question:
# For a regional grid (i.e. one that only has a tile 7) should the co-
# ordinates that target_lon and target_lat get set to be those of the 
# center of tile 6 (of the parent grid) or those of tile 7?  These two
# are not necessarily the same [although assuming there is only one re-
# gional domain within tile 6, i.e. assuming there is no tile 8, 9, etc,
# there is no reason not to center tile 7 with respect to tile 6].
  set_file_param "$FV3_NML_FP" "target_lon" "$lon_ctr_T6"
  set_file_param "$FV3_NML_FP" "target_lat" "$lat_ctr_T6"
elif [ "$grid_gen_method" = "JPgrid" ]; then
  set_file_param "$FV3_NML_FP" "target_lon" "$lon_rgnl_ctr"
  set_file_param "$FV3_NML_FP" "target_lat" "$lat_rgnl_ctr"
fi
set_file_param "$FV3_NML_FP" "stretch_fac" "$stretch_fac"
set_file_param "$FV3_NML_FP" "bc_update_interval" "$LBC_UPDATE_INTVL_HRS"
#
#-----------------------------------------------------------------------
#
# If CCPP is set to "true", copy the appropriate modulefile, the CCPP
# physics suite definition file (an XML file), and possibly other suite-
# dependent files to the experiment directory.
#
# The modulefile modules.nems in the directory
#
#   $NEMSfv3gfs_DIR/NEMS/src/conf
#
# is generated during the FV3 build process and this is configured pro-
# perly for the machine, shell environment, etc.  Thus, we can just copy
# it to the experiment directory without worrying about what machine 
# we're on, but this still needs to be confirmed.
#
# Note that a modulefile is a file whose first line is the "magic coo-
# kie" '#%Module'.  It is interpreted by the "module load ..." command.  
# It sets environment variables (including prepending/appending to 
# paths) and loads modules.
#
# QUESTION:
# Why don't we do this for the non-CCPP version of FV3?
#
# ANSWER:
# Because for that case, we load different versions of intel and impi 
# (compare modules.nems to the modules loaded for the case of CCPP set 
# to "false" in run_FV3SAR.sh).  Maybe these can be combined at some 
# point.  Note that a modules.nems file is generated in the same rela-
# tive location in the non-CCPP-enabled version of NEMSfv3gfs, so maybe
# that can be used and the run_FV3SAR.sh script modified to accomodate
# such a change.  That way the below can be performed for both the CCPP-
# enabled and non-CCPP-enabled versions of NEMSfv3gfs.
#
#-----------------------------------------------------------------------
#

# GSK 20190429:
# Cleaner to combine this with the CCPP if-statement above.  Do this at
# some point.

if [ "$CCPP" = "true" ]; then

  print_info_msg_verbose "\ 
Copying to the experiment directory the modulefile required for running
the CCPP-enabled version of the FV3SAR under NEMS..."

  cp_vrfy $NEMSfv3gfs_DIR/NEMS/src/conf/modules.nems $EXPTDIR/modules.fv3

  if [ "$CCPP_phys_suite" = "GFS" ]; then

    print_info_msg_verbose "\
Copying the GFS physics suite XML file to the experiment directory..."
    cp_vrfy $NEMSfv3gfs_DIR/ccpp/suites/suite_FV3_GFS_2017_gfdlmp.xml $EXPTDIR/suite_FV3_GFS_2017_gfdlmp.xml

  elif [ "$CCPP_phys_suite" = "GSD" ]; then

    print_info_msg_verbose "\
Copying the GSD physics suite XML file and the Thompson microphysics CCN fixed file to the experiment directory..."
    cp_vrfy $NEMSfv3gfs_DIR/ccpp/suites/suite_FV3_GSD_v0.xml $EXPTDIR/suite_FV3_GSD_v0.xml
    cp_vrfy $GSDFIX/CCN_ACTIVATE.BIN $EXPTDIR

  fi

fi


#
#-----------------------------------------------------------------------
#
# Copy files from various work directories into the experiment directory
# and create necesary links.
#
#-----------------------------------------------------------------------
#

# GSK 20190430:
# Now we only copy files into $EXPTDIR/INPUT but don't create links.  
# The links will be created in the INPUT subdirectory of each RUNDIR
# corresponding to each CDATE (forecast).  Thus, the comments and output
# messages here need to be modified.

print_info_msg_verbose "\
Copying files from work directories into run directory and creating links..."
#
#-----------------------------------------------------------------------
#
#
#
#-----------------------------------------------------------------------
#
if [ "${RUN_TASK_MAKE_GRID_OROG}" = "TRUE" ]; then
  target_dir=${WORKDIR_SHVE}
else
  target_dir=${PREGEN_GRID_OROG_DIR}
fi
#
# Get the (equivalent) C-resolution of the grid.  This is stored in the
# grid file as a global attribute.
#
cd_vrfy ${target_dir}
fn_pattern="C*_grid.tile7.halo${nh4_T7}.nc"
grid_fn=$( ls -1 $fn_pattern ) || \
print_err_msg_exit "${script_name}" "\
The \"ls\" command returned with a nonzero exit status."

num_files=$( printf "%s\n" "${grid_fn}" | wc -l )
if [ "${num_files}" -gt "1" ]; then
  print_err_msg_exit "${script_name}" "\
More than one file was found in directory PREGEN_GRID_OROG_DIR matching
the globbing pattern fn_pattern:
  PREGEN_GRID_OROG_DIR = \"$PREGEN_GRID_OROG_DIR\"
  fn_pattern = \"$fn_pattern\"
  num_files = \"$num_files\""
fi
#
# If the grid (and orography) generation task of the workflow was skip-
# ped (because pregenerated files are available), we need to calculate
# the global variables RES and CRES (and set them in the variable defi-
# nitions file) because these variables are normally calculated in that 
# task.
#
if [ "${RUN_TASK_MAKE_GRID_OROG}" != "TRUE" ]; then

  RES_equiv=$( ncdump -h "$grid_fn" | grep -o ":RES_equiv = [0-9]\+" | grep -o "[0-9]")
  RES_equiv=${RES_equiv//$'\n'/}
printf "%s\n" "RES_equiv = $RES_equiv"
  CRES_equiv="C${RES_equiv}"
printf "%s\n" "CRES_equiv = $CRES_equiv"

  RES="$RES_equiv"
  CRES="$CRES_equiv"

  set_file_param "${SCRIPT_VAR_DEFNS_FP}" "RES" "${RES}"
  set_file_param "${SCRIPT_VAR_DEFNS_FP}" "CRES" "${CRES}"

fi
#
#if [ "${RUN_TASK_MAKE_GRID_OROG}" = "TRUE" ]; then
#  cp_vrfy $WORKDIR_GRID/${CRES}_mosaic.nc $WORKDIR_SHVE
#fi
#
# Create array of files to which we will create symlinks.
#
file_list=( "${CRES}_mosaic.nc" \
            "${CRES}_grid.tile7.halo${nh3_T7}.nc" \
            "${CRES}_grid.tile7.halo${nh4_T7}.nc" \
            "${CRES}_oro_data.tile7.halo${nh4_T7}.nc" \
            "${CRES}_oro_data.tile7.halo${nh0_T7}.nc" \
          )
#
# Create symlinks in the INPUT subdirectory of the experiment directory
# to the grid files.
#
cd_vrfy $EXPTDIR/INPUT
for fn in "${file_list[@]}"; do
#
# Check that each target file exists before attempting to create sym-
# links.  This is because the "ln" command will create symlinks to non-
# existent targets without returning with a nonzero exit code.
#
  if [ -f "${target_dir}/$fn" ]; then
# Should links be made relative or absolute?  Maybe relative in community
# mode and absolute in nco mode?
    if [ "$RUN_ENVIR" = "nco" ]; then
      ln_vrfy -sf ${target_dir}/$fn .
    else
      ln_vrfy -sf --relative ${target_dir}/$fn .
    fi
  else
    print_err_msg_exit "${script_name}" "\
Cannot create symlink because target file (fn) in directory target_dir
does not exist:
  target_dir = \"${target_dir}\"
  fn = \"${fn}\""
  fi

done


#
#-----------------------------------------------------------------------
#
# Copy the fix files generated by the make_sfc_climo task from their 
# work directory to the experiment directory's INPUT subdirectory.
#
#-----------------------------------------------------------------------
#
if [ "${RUN_TASK_MAKE_SFC_CLIMO}" = "TRUE" ]; then
  target_dir=${WORKDIR_SFC_CLIMO}
else
  target_dir=${PREGEN_SFC_CLIMO_DIR}
fi

cd_vrfy ${target_dir}
fn_pattern="${CRES}.*.nc"
sfc_climo_files=$( ls -1 $fn_pattern ) || print_err_msg_exit "${script_name}" "\
The \"ls\" command returned with a nonzero exit status."
#
# Place the list of surface climatology files in an array.
#
file_list=()
i=0
while read crnt_file; do
  file_list[$i]="${crnt_file}"
  i=$((i+1))
done <<< "${sfc_climo_files}"
#
# Create symlinks in the INPUT subdirectory of the experiment directory
# to the surface climatology files.
#
cd_vrfy $EXPTDIR/INPUT
for fn in "${file_list[@]}"; do
#
# Check that each target file exists before attempting to create sym-
# links.  This is because the "ln" command will create symlinks to non-
# existent targets without returning with a nonzero exit code.
#
  if [ -f "${target_dir}/$fn" ]; then
# Should links be made relative or absolute?  Maybe relative in community
# mode and absolute in nco mode?
    if [ "$RUN_ENVIR" = "nco" ]; then
      ln_vrfy -sf ${target_dir}/$fn .
    else
      ln_vrfy -sf --relative ${target_dir}/$fn .
    fi
  else
    print_err_msg_exit "${script_name}" "\
Cannot create symlink because target file (fn) in directory target_dir
does not exist:
  target_dir = \"${target_dir}\"
  fn = \"${fn}\""
  fi

done


#
#-----------------------------------------------------------------------
#
# Create symlinks in the INPUT subdirectory of the experiment directory 
# to the halo-4 surface climatology files such that the link names do 
# not include a string specifying the halo width (e.g. "halo##", where 
# ## is the halo width in units of grid cells).  These links may be 
# needed by the chgres_cube code.
#
#-----------------------------------------------------------------------
#
cd_vrfy $EXPTDIR/INPUT

suffix=".halo${nh4_T7}.nc"
for fn in *${suffix}; do
  bn="${fn%.halo${nh4_T7}.nc}"
  ln_vrfy -fs ${bn}${suffix} ${bn}.nc
done
#
#-----------------------------------------------------------------------
#
# GSK 20190430:
# This is to make rocoto aware that the stage_static task has completed
# (so that other tasks can be launched).  This should be done through 
# rocoto's dependencies, but not sure how to do it yet.
#
#-----------------------------------------------------------------------
#
cd_vrfy $EXPTDIR
touch "stage_static_task_complete.txt"
#
#-----------------------------------------------------------------------
#
# Print message indicating successful completion of script.
#
#-----------------------------------------------------------------------
#
print_info_msg "\
========================================================================
All necessary STATIC files and links successfully copied to or created
in the experiment directory!!!
Exiting script:  \"${script_name}\"
========================================================================"
#
#-----------------------------------------------------------------------
#
# Restore the shell options saved at the beginning of this script/func-
# tion.
#
#-----------------------------------------------------------------------
#
{ restore_shell_opts; } > /dev/null 2>&1