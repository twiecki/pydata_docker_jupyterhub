Docker container with a PyData stack and JupyterHub server
==========================================================

PyData multi-user IPython/Jupyter notebook server docker container using JupyterHub and conda.

DockerHub: https://registry.hub.docker.com/u/twiecki/pydata-docker-jupyterhub/

To set up your own JupyterHub IPython server on top of this using PAM authentication for the Notebook users (the default), use the `add_user.sh` script from the scripts directory. Create a file called `users` with a line for every user that looks like this `<user>,<password>`.

```dockerfile
FROM twiecki/pydata-docker-jupyterhub

MAINTAINER Thomas Wiecki <thomas.wiecki@gmail.com>

# Set up shared folder
RUN mkdir /opt/shared_nbs
RUN chmod a+rwx /opt/shared_nbs

# If you have your own custom jupyterhub config, overwrite it.
ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

ADD users /tmp/users
ADD add_user.sh /tmp/add_user.sh
RUN bash /tmp/add_user.sh /tmp/users
RUN rm /tmp/add_user.sh /tmp/users
```