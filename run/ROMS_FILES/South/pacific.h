/*
** svn $Id: riverplume1.h 751 2015-01-07 22:56:36Z arango $
*******************************************************************************
** Copyright (c) 2002-2015 The ROMS/TOMS Group                               **
**   Licensed under a MIT/X style license                                    **
**   See License_ROMS.txt                                                    **
*******************************************************************************
**
** Options for East China Sea.
**
** Application flag:   JSC
** Input script:       jsc_ocean.in
** Copyright:          Yu Liu
*/
/******************************Basis Equations options *********************/
#define SOLVE3D
#define UV_COR
#define UV_ADV
#define UV_U3HADVECTION
#define UV_C4VADVECTION

#define UV_VIS2
#define TS_DIF2
#define SALINITY
#define MIX_GEO_TS              /* mixing on geopotential (constant Z) surface */
#define MIX_S_UV                /*  use if mixing along constant S-surfaces    */ 
#define NONLIN_EOS         

#define DJ_GRADPS               /* pressure gradient term using splines density Jacobian (Shchepetkin,2000) */
#define UV_QDRAG              
#define TS_MPDATA               /* recursive MPDATA 3D advection for tracer   */

#undef  QCORRECTION             /*  use if net heat flux correction        */
#undef  SCORRECTION             /*  use if freshwater flux correction      */ 

/***************************** Model Configuration OPTIONS ********************/
#define CURVGRID
#define MASKING
#define SPHERICAL
#undef WET_DRY
#define AVERAGES
#undef AVERAGES_DETIDE
#undef SPLINES
#define SPHERICAL

/****************************  Options for atmospheric boundary layer   ***************************/  
/* default net longwave radiation */

#define BULK_FLUXES            /* use if bulk fluxes computation */
#define EMINUSP

/************************ Options for vertical mixing of momentum and tracers ******************/
#define MY25_MIXING
#ifdef MY25_MIXING
#  define N2S2_HORAVG          /* use if horizontal smoothing of buoyancy/shear */ 
#  define KANTHA_CLAYSON       /* use if kantha and clayson stability function */
#endif

#undef LMD_MIXING
#ifdef LMD_MIXING
# define LMD_RIMIX
# define LMD_CONVEC
# define LMD_SKPP
# define LMD_BKPP
# define LMD_NONLOCAL
#endif

/************************ options for open boundary conditions **********************/
#define ANA_SPONGE
#undef SSH_TIDES
#undef UV_TIDES
#undef RAMP_TIDES
#define NO_LBC_ATT
#define ANA_BSFLUX
#define ANA_BTFLUX



