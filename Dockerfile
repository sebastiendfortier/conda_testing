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

RUN mamba create -q -y -n python-rpn-39 python=3.9 fortiers::eccc_rpnpy

RUN . activate python-rpn-39 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-39 && python -c "import rpnpy.tdpack.all" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n python-rpn-310 python=3.10 fortiers::eccc_rpnpy

RUN . activate python-rpn-310 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-310 && python -c "import rpnpy.tdpack.all" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n python-rpn-311 python=3.11 fortiers::eccc_rpnpy

RUN . activate python-rpn-311 && python -c "import rpnpy.librmn.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.vgd.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.utils.fstd3d" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.rpndate" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.burpc.all" || exit 1
RUN . activate python-rpn-311 && python -c "import rpnpy.tdpack.all" || exit 1
################################################################

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-39 python=3.9 fortiers::domcmc

RUN . activate domcmc-39 && python -c "import domcmc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-310 python=3.10 fortiers::domcmc

RUN . activate domcmc-310 && python -c "import domcmc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n domcmc-311 python=3.11 fortiers::domcmc

RUN . activate domcmc-311 && python -c "import domcmc" || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-39 python=3.9 fortiers::fstd2nc

RUN . activate fstd2nc-39 && python -c "import fstd2nc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-310 python=3.10 fortiers::fstd2nc

RUN . activate fstd2nc-310 && python -c "import fstd2nc" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstd2nc-311 python=3.11 fortiers::fstd2nc

RUN . activate fstd2nc-311 && python -c "import fstd2nc" || exit 1
################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-39 python=3.9 fortiers::fstpy

RUN . activate fstpy-39 && python -c "import fstpy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-310 python=3.10 fortiers::fstpy

RUN . activate fstpy-310 && python -c "import fstpy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n fstpy-311 python=3.11 fortiers::fstpy

RUN . activate fstpy-311 && python -c "import fstpy" || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-39 python=3.9 fortiers::ci_fstcomp

RUN . activate ci_fstcomp-39 && python -c "import ci_fstcomp" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-310 python=3.10 fortiers::ci_fstcomp

RUN . activate ci_fstcomp-310 && python -c "import ci_fstcomp" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n ci_fstcomp-311 python=3.11 fortiers::ci_fstcomp

RUN . activate ci_fstcomp-311 && python -c "import ci_fstcomp" || exit 1

################################################################
RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-39 python=3.9 fortiers::spookipy

RUN . activate spookipy-39 && python -c "import spookipy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-310 python=3.10 fortiers::spookipy

RUN . activate spookipy-310 && python -c "import spookipy" || exit 1

RUN conda clean -y --all

RUN mamba create -q -y -n spookipy-311 python=3.11 fortiers::spookipy

RUN . activate spookipy-311 && python -c "import spookipy" || exit 1

################################################################
