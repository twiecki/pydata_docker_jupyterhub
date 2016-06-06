FROM jupyter/jupyterhub

MAINTAINER Thomas Wiecki <thomas.wiecki@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget libsm6 libxrender1 libfontconfig1 libglib2.0-0

# Install miniconda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/miniconda3/bin:$PATH
RUN chmod -R a+rx /opt/miniconda3

# Install PyData modules and IPython dependencies
RUN conda update --quiet --yes conda && \
    conda install --quiet --yes numpy scipy pandas matplotlib cython pyzmq scikit-learn seaborn six statsmodels theano pip tornado jinja2 sphinx pygments nose readline sqlalchemy ipython jupyter

# Set up IPython kernel
RUN rm -rf /usr/local/share/jupyter/kernels/* && \
    python -m IPython kernelspec install-self

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN conda clean -y -t

# Test
RUN python -c "import numpy, scipy, pandas, matplotlib, matplotlib.pyplot, sklearn, seaborn, statsmodels, theano"
