import domcmc
import domcmc.fst_tools as fst_tools
fst_file = 'test_file.std'
p0 = fst_tools.get_data(file_name=fst_file, var_name='TT')
print(p0.keys())
print(p0['values'].shape)
