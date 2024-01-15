import numpy  as np
import sys

from rpnpy.rpndate import RPNDate
import rpnpy.burpc.all as brp
import rpnpy.librmn.all as rmn
import rpnpy.tdpack.all as tdpack
import rpnpy.utils.fstd3d as fstd3d
import rpnpy.vgd.all as vgd

print (rmn.RMN_VERSION)
print (rmn.RMN_LIBPATH)

(yyyymmdd, hhmmsshh) = (20150123, 0)
print('--- newdate test ---')
print(yyyymmdd, hhmmsshh)
try:
    idate1 = rmn.newdate(rmn.NEWDATE_PRINT2STAMP, yyyymmdd, hhmmsshh)
    (yyyymmdd2, hhmmsshh2) = rmn.newdate(rmn.NEWDATE_STAMP2PRINT, idate1)
    print(yyyymmdd2, hhmmsshh2)
except rmn.RMNBaseError:
    sys.stderr.write("There was a problem encoding/decoding the date.")



print('--- vgrid test ---')
try:
    myvgd0 = vgd.vgd_new_pres((500.,850.,1000.))
    myvgd1 = vgd.vgd_new_pres((550.,900.,1013.))
except:
    sys.stderr.write("There was a problem creating the VGridDescriptor")
    sys.exit(1)
if vgd.vgd_cmp(myvgd0, myvgd1):
    print("# The 2 VGridDescriptors are identical.")
else:
    print("# The 2 VGridDescriptors differ.")



params0 = {
    'grtyp' : 'Z',
    'grref' : 'E',
    'ni'    : 90,
    'nj'    : 45,
    'lat0'  : 10.,
    'lon0'  : 11.,
    'dlat'  : 1.,
    'dlon'  : 0.5,
    'xlat1' : 0.,
    'xlon1' : 180.,
    'xlat2' : 1.,
    'xlon2' : 270.
    }
hgrid = rmn.encodeGrid(params0)

lvls  = (0.013,   0.027,    0.051,    0.075,
         0.101,   0.127,    0.155,    0.185,    0.219,
         0.258,   0.302,    0.351,    0.405,    0.460,
         0.516,   0.574,    0.631,    0.688,    0.744,
         0.796,   0.842,    0.884,    0.922,    0.955,
         0.980,   0.995)
rcoef1 = 0.
rcoef2 = 1.
pref   = 100000.
dhm    = 10.
dht    = 2.
try:
    vptr = vgd.vgd_new_hybmd(lvls, rcoef1, rcoef2, pref, dhm, dht)
except vgd.VGDError:
    sys.stderr.write("There was a problem creating the VGridDescriptor")
vgrid = fstd3d.vgrid_new('VIPT', vptr, rfldError=False)

params = rmn.FST_RDE_META_DEFAULT.copy()
params['nomvar'] = 'tt'
params['dateo'] = RPNDate(20190625, 0).stamp
params['deet'] = 1800
params['npas'] = 6
params['etiket'] = 'myetk'

# Create new 3d field for TT on vgrid Thermo levels
field3d = fstd3d.fst_new_3d(params, hgrid, vgrid=vgrid)

field3d['d'] = 0.

print(field3d)


print('--- tdpack test ---')
hu = np.array([0.00001], dtype=np.float32, order='F')
tt = np.array([273.15], dtype=np.float32, order='F')
pp = np.array([80000.], dtype=np.float32, order='F')
try:
    hr = tdpack.mhuahr(hu, tt, pp)
    print(hr)
except tdpack.TDPackError:
    sys.stderr.write("There was a problem computing HR.")


print('--- burpc test ---')

m = brp.brp_opt(rmn.BURPOP_MSGLVL, rmn.BURPOP_MSG_SYSTEM)
# /fs/ssm/eccc/mrd/rpn/MIG/GEM/d/gem-data/gem-data_4.2.0/gem-data_4.2.0_all/share/data/dfiles

# Open file in read only mode
bfile = brp.BurpcFile('2007021900.brp')

# get the first report in file and print some info
rpt = bfile[0]

# get the first block in report
blk = rpt[0]
print("# block bkno = {}, {}, {}".format(blk.bkno, blk.bknat_kindd, blk.bktyp_kindd))
# block bkno = 1, data, data seen by OA at altitude, global model

# Copy a block
blk1 = brp.BurpcBlk(blk)
blk1.btyp = 6
print("# block bkno = {}, {}, {}".format(blk.bkno, blk.bknat_kindd, blk.bktyp_kindd))
# block bkno = 1, data, data seen by OA at altitude, global model
print("# block bkno = {}, {}, {}".format(blk1.bkno, blk1.bknat_kindd, blk1.bktyp_kindd))
# block bkno = 1, data, observations (ADE)

# get the first element in blk
ele = blk[0]
print("# {}: {}, (units={}), shape=[{}, {}] : value={}"
      .format(ele.e_bufrid, ele.e_desc, ele.e_units, ele.nval, ele.nt, ele.e_rval[0,0]))
# 10004: PRESSURE, (units=PA), shape=[1, 1] : value=100.0

# Loop over all elements in block and print info for last one
for ele in blk:
    pass  # Do something with the element
print("# {}: {}, (units={}), shape=[{}, {}] : value={:7.2e}"
      .format(ele.e_bufrid, ele.e_desc, ele.e_units, ele.nval, ele.nt, ele.e_rval[0,0]))
# 13220: NATURAL LOG SFC SPEC HUMIDITY (2M), (units=LN(KG/KG)), shape=[1, 1] : value=1.00e+30

# New empty block
blk = brp.BurpcBlk()

# New block from dict
blk = brp.BurpcBlk({'bkno' : 1, 'btyp' : 6})
print("# block bkno = {}, {}, {}".format(blk.bkno, blk.bknat_kindd, blk.bktyp_kindd))
# block bkno = 1, data, observations (ADE)
