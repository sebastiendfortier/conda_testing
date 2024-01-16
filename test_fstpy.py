import fstpy
df = fstpy.StandardFileReader('test_file.std').to_pandas()
df.drop(columns='d')
