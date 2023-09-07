#!/bin/bash
wget https://anl.box.com/shared/static/gvaj3bq33rhfig8d96vxxjnq3bi08px5.tgz
tar -xzvf gvaj3bq33rhfig8d96vxxjnq3bi08px5.tgz
rm gvaj3bq33rhfig8d96vxxjnq3bi08px5.tgz
git clone git@github.com:jtramm/openmc_offloading_benchmarks.git
