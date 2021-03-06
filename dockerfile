FROM alpine:3.7
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk8-jre
RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 ; fi && \
rm -r /root/.cache
RUN pip3 install --upgrade pip
RUN apk add --update  python python3 python-dev python3-dev gfortran py-pip build-base
RUN apk update && apk add --no-cache libc6-compat
RUN BLAS=~/src/BLAS/libfblas.a LAPACK=~/src/lapack-3.5.0/liblapack.a pip install -v numpy==1.14
RUN  pip3 install wheel
RUN  pip3 install pyspark==2.3.2 --no-cache-dir
RUN  pip3 install findspark
RUN  pip3 install numpy
RUN  pip3 install prettytable
COPY dockertest.py dockertest.py
COPY TestDataset.csv TestDataset.csv
COPY TrainingDataset.csv TrainingDataset.csv
COPY model model
RUN ls -la /*
CMD ["python3", "dockertest.py"]
