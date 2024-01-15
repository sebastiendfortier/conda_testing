import argparse
import subprocess
import os

def run_notebooks(notebooks, kernels):
  for notebook in notebooks:
      for kernel in kernels:
          cmd = f"jupyter nbconvert --execute --to notebook --ExecutePreprocessor.timeout=600 --ExecutePreprocessor.kernel_name={kernel} {notebook}"
          proc = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
          
          if proc.returncode != 0:
              print(f"Error running {notebook} with {kernel}:")
              print(proc.stderr.decode())
          else:
              print(f"Successfully ran {notebook} with {kernel}")

def main():
   parser = argparse.ArgumentParser(description='Run Jupyter notebooks with different kernels.')
   parser.add_argument('--notebooks', nargs='+', required=True, help='List of notebooks to test.')
   parser.add_argument('--kernels', nargs='+', required=True, help='List of kernels to test.')
   args = parser.parse_args()
   
   run_notebooks(args.notebooks, args.kernels)

if __name__ == "__main__":
   main()
