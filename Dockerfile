FROM condaforge/miniforge3:latest

ARG ARCH
ARG UID
ARG GID
ARG UNAME
ARG GNAME
RUN groupadd -g $GID -o $GNAME && \
    useradd -u $UID -g $GID -ms /bin/bash $UNAME 

SHELL ["/bin/bash", "-c"]

COPY 02nocache /etc/apt/apt.conf.d/02nocache
COPY 01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

COPY table_b_bufr_e /share/table_b_bufr_e

RUN apt-get update -y && \
    apt-get install -y build-essential git nano make gfortran

USER $UNAME

WORKDIR /home/${UNAME}

COPY 2007021900.brp .
COPY 2007021900.brp .
COPY kernel_tester.py .
COPY test_ci_fstcomp.ipynb .
COPY test_ci_fstcomp.py .
COPY test_domcmc.ipynb .
COPY test_domcmc.py .
COPY test_fstd2nc.ipynb .
COPY test_fstd2nc.py .
COPY test_fstpy.ipynb .
COPY test_fstpy.py .
COPY test_python-rpn.ipynb .
COPY test_python-rpn.py .
COPY test_spookipy.ipynb .
COPY test_spookipy.py .
COPY control.ipynb .
COPY test_control.sh .

################################################################

RUN mamba create -q -y -n python-rpn-39 python=3.9 fortiers::eccc_rpnpy ipykernel jupyter

RUN . activate python-rpn-39 && python -m ipykernel install --user --name python-rpn-39 --display-name="python-rpn-39"

RUN . activate python-rpn-39 && python test_python-rpn.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n python-rpn-310 python=3.10 fortiers::eccc_rpnpy ipykernel jupyter; \
   . activate python-rpn-310 && python -m ipykernel install --user --name python-rpn-310 --display-name="python-rpn-310"; \
   . activate python-rpn-310 && python test_python-rpn.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n python-rpn-311 python=3.11 fortiers::eccc_rpnpy ipykernel jupyter; \
   . activate python-rpn-311 && python -m ipykernel install --user --name python-rpn-311 --display-name="python-rpn-311"; \
   . activate python-rpn-311 && python test_python-rpn.py || exit 1; \
   conda clean -y --all; \
   fi

RUN mamba create -q -y -n tester python=3.9 nbformat nbconvert jupyter

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_python-rpn.ipynb --kernels python-rpn-39 python-rpn-310 python-rpn-311 || exit 1; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_python-rpn.ipynb --kernels python-rpn-39 || exit 1; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/sebastiendfortier/python-rpn.git

RUN mamba create -q -y -n python-rpn-tester python=3.9 pytz numpy scipy fortiers::eccc_librmn fortiers::eccc_libezinterpv fortiers::eccc_libtdpack fortiers::eccc_libvgrid fortiers::eccc_libburpc

RUN . activate python-rpn-tester && \
    cd python-rpn && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_python-rpn.py || exit 1

################################################################

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-39 python=3.9 fortiers::domcmc ipykernel jupyter

RUN . activate domcmc-39 && python -m ipykernel install --user --name domcmc-39 --display-name="domcmc-39"

RUN . activate domcmc-39 && python test_domcmc.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n domcmc-310 python=3.10 fortiers::domcmc ipykernel jupyter; \ 
   . activate domcmc-310 && python -m ipykernel install --user --name domcmc-310 --display-name="domcmc-310"; \
   . activate domcmc-310 && python test_domcmc.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n domcmc-311 python=3.11 fortiers::domcmc ipykernel jupyter; \ 
   . activate domcmc-311 && python -m ipykernel install --user --name domcmc-311 --display-name="domcmc-311"; \ 
   . activate domcmc-311 && python test_domcmc.py || exit 1; \ 
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_domcmc.ipynb --kernels domcmc-39 domcmc-310 domcmc-311 || exit 1; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_domcmc.ipynb --kernels domcmc-39 || exit 1; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/sebastiendfortier/domcmc.git

RUN mamba create -q -y -n domcmc-tester python=3.9 fortiers::eccc_rpnpy

RUN . activate domcmc-tester && \
    cd domcmc && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_domcmc.py || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-39 python=3.9 fortiers::fstd2nc ipykernel jupyter

RUN . activate fstd2nc-39 && python -m ipykernel install --user --name fstd2nc-39 --display-name="fstd2nc-39"

RUN . activate fstd2nc-39 && python test_fstd2nc.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n fstd2nc-310 python=3.10 fortiers::fstd2nc ipykernel jupyter; \ 
   . activate fstd2nc-310 && python -m ipykernel install --user --name fstd2nc-310 --display-name="fstd2nc-310"; \
   . activate fstd2nc-310 && python test_fstd2nc.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n fstd2nc-311 python=3.11 fortiers::fstd2nc ipykernel jupyter; \ 
   . activate fstd2nc-311 && python -m ipykernel install --user --name fstd2nc-311 --display-name="fstd2nc-311"; \ 
   . activate fstd2nc-311 && python test_fstd2nc.py || exit 1; \ 
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_fstd2nc.ipynb --kernels fstd2nc-39 fstd2nc-310 fstd2nc-311 || exit 1; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_fstd2nc.ipynb --kernels fstd2nc-39 || exit 1; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/neishm/fstd2nc.git

RUN mamba create -q -y -n fstd2nc-tester python=3.9 fortiers::eccc_rpnpy

RUN . activate fstd2nc-tester && \
    cd fstd2nc && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_fstd2nc.py || exit 1 && \
    fstd2nc --version || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-39 python=3.9 fortiers::fstpy ipykernel jupyter

RUN . activate fstpy-39 && python -m ipykernel install --user --name fstpy-39 --display-name="fstpy-39"

RUN . activate fstpy-39 && python test_fstpy.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n fstpy-310 python=3.10 fortiers::fstpy ipykernel jupyter; \ 
   . activate fstpy-310 && python -m ipykernel install --user --name fstpy-310 --display-name="fstpy-310"; \
   . activate fstpy-310 && python test_fstpy.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n fstpy-311 python=3.11 fortiers::fstpy ipykernel jupyter; \ 
   . activate fstpy-311 && python -m ipykernel install --user --name fstpy-311 --display-name="fstpy-311"; \ 
   . activate fstpy-311 && python test_fstpy.py || exit 1; \ 
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_fstpy.ipynb --kernels fstpy-39 fstpy-310 fstpy-311 || exit 1 ; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_fstpy.ipynb --kernels fstpy-39 || exit 1 ; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/sebastiendfortier/fstpy.git

RUN mamba create -q -y -n fstpy-tester python=3.9 fortiers::eccc_rpnpy

RUN . activate fstpy-tester && \
    cd fstpy && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_fstpy.py || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-39 python=3.9 fortiers::ci_fstcomp ipykernel jupyter

RUN . activate ci_fstcomp-39 && python -m ipykernel install --user --name ci_fstcomp-39 --display-name="ci_fstcomp-39"

RUN . activate ci_fstcomp-39 && python test_ci_fstcomp.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n ci_fstcomp-310 python=3.10 fortiers::ci_fstcomp ipykernel jupyter; \ 
   . activate ci_fstcomp-310 && python -m ipykernel install --user --name ci_fstcomp-310 --display-name="ci_fstcomp-310"; \
   . activate ci_fstcomp-310 && python test_ci_fstcomp.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n ci_fstcomp-311 python=3.11 fortiers::ci_fstcomp ipykernel jupyter; \ 
   . activate ci_fstcomp-311 && python -m ipykernel install --user --name ci_fstcomp-311 --display-name="ci_fstcomp-311"; \ 
   . activate ci_fstcomp-311 && python test_ci_fstcomp.py || exit 1; \ 
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_ci_fstcomp.ipynb --kernels ci_fstcomp-39 ci_fstcomp-310 ci_fstcomp-311 || exit 1 ; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_ci_fstcomp.ipynb --kernels ci_fstcomp-39 || exit 1 ; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/sebastiendfortier/ci_fstcomp.git

RUN mamba create -q -y -n ci_fstcomp-tester python=3.9 fortiers::eccc_rpnpy

RUN . activate ci_fstcomp-tester && \
    cd ci_fstcomp && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_ci_fstcomp.py || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-39 python=3.9 fortiers::spookipy ipykernel jupyter

RUN . activate spookipy-39 && python -m ipykernel install --user --name spookipy-39 --display-name="spookipy-39"

RUN . activate spookipy-39 && python test_spookipy.py || exit 1

RUN conda clean -y --all

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n spookipy-310 python=3.10 fortiers::spookipy ipykernel jupyter; \ 
   . activate spookipy-310 && python -m ipykernel install --user --name spookipy-310 --display-name="spookipy-310"; \
   . activate spookipy-310 && python test_spookipy.py || exit 1; \
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   mamba create -q -y -n spookipy-311 python=3.11 fortiers::spookipy ipykernel jupyter; \ 
   . activate spookipy-311 && python -m ipykernel install --user --name spookipy-311 --display-name="spookipy-311"; \ 
   . activate spookipy-311 && python test_spookipy.py || exit 1; \ 
   conda clean -y --all; \
   fi

RUN if [ "$ARCH" != "ppc64le" ]; then \
   echo "Running commands for $ARCH"; \
   . activate tester; \
   python kernel_tester.py --notebooks test_spookipy.ipynb --kernels spookipy-39 spookipy-310 spookipy-311 || exit 1 ; \
   conda clean -y --all; \
   else \
   . activate tester; \
   python kernel_tester.py --notebooks test_spookipy.ipynb --kernels spookipy-39 || exit 1 ; \
   conda clean -y --all; \
   fi

WORKDIR /home/${UNAME}

RUN git clone --recursive https://github.com/sebastiendfortier/spookipy.git

RUN mamba create -q -y -n spookipy-tester python=3.9 fortiers::eccc_rpnpy

RUN . activate spookipy-tester && \
    cd spookipy && \
    python -m pip install . && \
    cd /home/${UNAME} && \
    python test_spookipy.py || exit 1

################################################################

WORKDIR /home/${UNAME}


