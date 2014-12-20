FROM jupyter/jupyterhub

MAINTAINER Thomas Wiecki <thomas.wiecki@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget libsm6 libxrender1 libfontconfig1

# Install miniconda
RUN wget --quiet http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    bash Miniconda-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda-latest-Linux-x86_64.sh
ENV PATH /opt/miniconda/bin:$PATH
RUN chmod -R a+rx /opt/miniconda

# Install PyData modules and IPython dependencies
RUN conda update --quiet --yes conda && \
    conda install --quiet --yes numpy scipy pandas matplotlib cython pyzmq scikit-learn seaborn six statsmodels theano pip tornado jinja2 sphinx pygments nose readline sqlalchemy

# Set up IPython kernel
RUN pip install file:///srv/ipython && \
    rm -rf /usr/local/share/ipython/kernels/* && \
    python2 -m IPython kernelspec install-self --system

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN conda clean -y -t

# Test
RUN python -c "import numpy, scipy, pandas, matplotlib, matplotlib.pyplot, sklearn, seaborn, statsmodels, theano"
