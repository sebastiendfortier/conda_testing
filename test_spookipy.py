import spookipy
import fstpy

df = fstpy.StandardFileReader('test_file.std').to_pandas()
df.drop(columns='d')

fstpy.voir(df)
# compute uv on the selected records
uv_df = spookipy.windmodulus(df).compute()
uv_df.drop(columns='d')

pres_df = spookipy.Pressure(df, reference_field='TT').compute()
pres_df.drop(columns='d')

tt_df = fstpy.select_with_meta(df, 'TT')
fil_df = spookipy.FilterDigital(tt_df, filter=[1,2,1], repetitions=2).compute()
