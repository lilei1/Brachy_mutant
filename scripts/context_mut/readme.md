Objective: This is for look for the context motif surrounding the induced mutations or natural variations.

Note: this one is running in the MSI and collaborate with Peter Morrell in UMN.


### Install the mutation motif

```
conda env remove -n mut_motif
module load python/3.8.3_anaconda2020.07_mamba
conda create -n mut_motif -c plotly python=3.8 plotly plotly-orca rpy2 
conda install -n mut_motif scipy scikit-learn
conda install -n mut_motif attrs=18.2

conda activate mut_motif
python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

```

Then I got errors:
```
ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
ldpop 1.0.0 requires future, which is not installed.
pyrho 0.1.6 requires pytest>=3.0.7, which is not installed.
pyrho 0.1.6 requires tables>=3.3.0, which is not installed.
tskit 0.4.1 requires jsonschema>=3.0.0, which is not installed.

```

So I have to install other stuff

```
pip install future
pip install pytest-3.0.7
pip install pytest
pip install tables
pip install jsonschema
python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

There is a bug:
python -m pip uninstall mutation_motif

python -m pip install git+https://github.com/HuttleyLab/MutationMotif.git@develop#egg=mutation_motif

```


