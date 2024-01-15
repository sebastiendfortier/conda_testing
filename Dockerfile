FROM condaforge/miniforge3:latest

ARG UID
ARG GID
ARG UNAME
ARG GNAME
RUN groupadd -g $GID -o $GNAME && \
    useradd -u $UID -g $GID -ms /bin/bash $UNAME 

SHELL ["/bin/bash", "-c"]

COPY 02nocache /etc/apt/apt.conf.d/02nocache
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

# RUN apt-get update -y && \
#     apt-get install -y git nano

USER $UNAME

WORKDIR /home/${UNAME}

COPY kernel_tester.py .
COPY test_ci_fstcomp.ipynb .
COPY test_domcmc.ipynb .
COPY test_fstd2nc.ipynb .
COPY test_fstpy.ipynb .
COPY test_python-rpn.ipynb .
COPY test_spookipy.ipynb .

RUN mamba create -q -y -n python-rpn-39 python=3.9 fortiers::eccc_rpnpy ipykernel

RUN . activate python-rpn-39 && python -m ipykernel install --user --name python-rpn-39 --display-name="python-rpn-39"

RUN . activate python-rpn-39 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.tdpack.all" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n python-rpn-310 python=3.10 fortiers::eccc_rpnpy ipykernel

RUN . activate python-rpn-310 && python -m ipykernel install --user --name python-rpn-310 --display-name="python-rpn-310"

RUN . activate python-rpn-310 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.tdpack.all" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n python-rpn-311 python=3.11 fortiers::eccc_rpnpy ipykernel

RUN . activate python-rpn-311 && python -m ipykernel install --user --name python-rpn-310 --display-name="python-rpn-310"

RUN . activate python-rpn-311 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.tdpack.all" || exit 1

RUN mamba create -q -y -n tester nbformat nbconvert

RUN . activate tester && \
    python kernel_tester.py --notebooks test_python-rpn.ipynb --kernels python-rpn-39 python-rpn-310 python-rpn-311 
 
################################################################

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-39 python=3.9 fortiers::domcmc ipykernel

RUN . activate domcmc-39 && python -m ipykernel install --user --name domcmc-39 --display-name="domcmc-39"

RUN . activate domcmc-39 && python -c "import domcmc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-310 python=3.10 fortiers::domcmc ipykernel

RUN . activate domcmc-310 && python -m ipykernel install --user --name domcmc-310 --display-name="domcmc-310"

RUN . activate domcmc-310 && python -c "import domcmc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-311 python=3.11 fortiers::domcmc ipykernel

RUN . activate domcmc-311 && python -m ipykernel install --user --name domcmc-311 --display-name="domcmc-311"

RUN . activate domcmc-311 && python -c "import domcmc" || exit 1

RUN . activate tester && \
    python kernel_tester.py --notebooks test_domcmc.ipynb --kernels domcmc-39 domcmc-310 domcmc-311 

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-39 python=3.9 fortiers::fstd2nc ipykernel

RUN . activate fstd2nc-39 && python -m ipykernel install --user --name fstd2nc-39 --display-name="fstd2nc-39"

RUN . activate fstd2nc-39 && python -c "import fstd2nc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-310 python=3.10 fortiers::fstd2nc ipykernel

RUN . activate fstd2nc-310 && python -m ipykernel install --user --name fstd2nc-310 --display-name="fstd2nc-310"

RUN . activate fstd2nc-310 && python -c "import fstd2nc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-311 python=3.11 fortiers::fstd2nc ipykernel

RUN . activate fstd2nc-311 && python -m ipykernel install --user --name fstd2nc-311 --display-name="fstd2nc-311"

RUN . activate fstd2nc-311 && python -c "import fstd2nc" || exit 1

RUN . activate tester && \
    python kernel_tester.py --notebooks test_fstd2nc.ipynb --kernels fstd2nc-39 fstd2nc-310 fstd2nc-311 

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-39 python=3.9 fortiers::fstpy ipykernel

RUN . activate fstpy-39 && python -m ipykernel install --user --name fstpy-39 --display-name="fstpy-39"

RUN . activate fstpy-39 && python -c "import fstpy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-310 python=3.10 fortiers::fstpy ipykernel

RUN . activate fstpy-310 && python -m ipykernel install --user --name fstpy-310 --display-name="fstpy-310"

RUN . activate fstpy-310 && python -c "import fstpy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-311 python=3.11 fortiers::fstpy ipykernel

RUN . activate fstpy-311 && python -m ipykernel install --user --name fstpy-311 --display-name="fstpy-311"

RUN . activate fstpy-311 && python -c "import fstpy" || exit 1

RUN . activate tester && \
    python kernel_tester.py --notebooks test_fstpy.ipynb --kernels fstpy-39 fstpy-310 fstpy-311 

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-39 python=3.9 fortiers::ci_fstcomp ipykernel

RUN . activate ci_fstcomp-39 && python -m ipykernel install --user --name ci_fstcomp-39 --display-name="ci_fstcomp-39"

RUN . activate ci_fstcomp-39 && python -c "import ci_fstcomp" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-310 python=3.10 fortiers::ci_fstcomp ipykernel

RUN . activate ci_fstcomp-310 && python -m ipykernel install --user --name ci_fstcomp-310 --display-name="ci_fstcomp-310"

RUN . activate ci_fstcomp-310 && python -c "import ci_fstcomp" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-311 python=3.11 fortiers::ci_fstcomp ipykernel

RUN . activate ci_fstcomp-311 && python -m ipykernel install --user --name ci_fstcomp-311 --display-name="ci_fstcomp-311"

RUN . activate ci_fstcomp-311 && python -c "import ci_fstcomp" || exit 1

RUN . activate tester && \
    python kernel_tester.py --notebooks test_ci_fstcomp.ipynb --kernels ci_fstcomp-39 ci_fstcomp-310 ci_fstcomp-311 

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-39 python=3.9 fortiers::spookipy ipykernel

RUN . activate spookipy-39 && python -m ipykernel install --user --name spookipy-39 --display-name="spookipy-39"

RUN . activate spookipy-39 && python -c "import spookipy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-310 python=3.10 fortiers::spookipy ipykernel

RUN . activate spookipy-310 && python -m ipykernel install --user --name spookipy-310 --display-name="spookipy-310"

RUN . activate spookipy-310 && python -c "import spookipy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-311 python=3.11 fortiers::spookipy ipykernel

RUN . activate spookipy-311 && python -m ipykernel install --user --name spookipy-311 --display-name="spookipy-311"

RUN . activate spookipy-311 && python -c "import spookipy" || exit 1

RUN . activate tester && \
    python kernel_tester.py --notebooks test_spookipy.ipynb --kernels spookipy-39 spookipy-310 spookipy-311 

################################################################
