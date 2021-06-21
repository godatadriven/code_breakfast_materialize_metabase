# Runbook of the code breakfast
## Materialize setup
1. Make sure Docker is running in your machine.
2. Install libpq (to get the psql CLI) <br>
    a. Mac (with Homebrew)
```bash
# install libpq
brew install libpq
# export the location of libpq's bin to PATH in your .bash_profile file
vim .bash_profile
# then copy this at the end
export PATH=$PATH:/usr/local/Cellar/libpq/<your_libpq_version>/bin
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
b. Linux

```bash
sudo apt-get install postgresql-client
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
c. Windows

3. Run the following command in your terminal
```bash
docker run -p 6875:6875 materialize/materialized:v0.7.2
```
4. Then run the following from your terminal to connect to Materialize through the CLI:
```bash
psql -U materialize -h localhost -p 6875 materialize
```
*I prepared this tutorial with version 0.7.2, although the latest is 0.8.0*
## Metabase setup

## Connect to a Pubnub source

## Create a view on top of the source

## Create connection from Metabase to Materialize

## Build a materialized view

## Create a dashboard in Metabase