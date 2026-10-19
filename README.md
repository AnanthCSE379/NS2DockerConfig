# Computer Networks lab: Ubuntu 16.04 + ns2

This container provides ns2, NAM, xgraph, Tcl/Tk, and gawk. It runs an Intel Ubuntu Xenial image through Docker Desktop.

## Start

Start Docker Desktop, then in a Mac terminal: (Note path has to be changed to respective path, this is from my side

```sh
cd /Users/ananth/Documents/CN_Lab
./lab start
```

Open the Linux desktop:

http://localhost:6080/vnc.html?autoconnect=true&resize=scale

If prompted, click Connect. The desktop is accessible only from this Mac. No XQuartz installation is needed. Right-click the desktop to open the Fluxbox menu if you need another terminal.

## Run your experiments

The desktop terminal starts in `/work`, which is your Mac's `CN_Lab` folder. Run normal Linux commands there:

```sh
ns test2.tcl
ns exp6-cc1-reno-.tcl
nam wired.nam
xgraph reno_Sender_throughput
```

Scripts containing `exec nam ... &` or `exec xgraph ... &` automatically open their windows on this desktop. In NAM, press Play to animate the simulation.

You can also run tools from a Mac terminal:

```sh
./lab ns test2.tcl
./lab ns 'wireless (1).tcl'
./lab nam wired.nam
./lab xgraph reno_Sender_throughput
./lab shell
```

GUI windows appear in the browser even when launched from the Mac terminal. Exit `./lab shell` with `exit`. Close NAM and xgraph windows when finished.

Edit Tcl files on your Mac as usual; changes are immediately visible inside `/work`. Simulation outputs are also saved in your Mac folder. Scripts can overwrite their previous output files, so use separate working directories when you want to preserve runs.

## Stop and restart

```sh
./lab stop
./lab start
```

Files in `/work` survive container recreation. Files elsewhere inside the container may not. Closing the browser does not stop the container.

## Troubleshooting

- Docker connection error: start Docker Desktop and wait for its engine to become ready.
- Desktop fails to connect: run `docker compose ps` and `docker compose logs --tail=80` from this folder.
- A Tcl error or missing data/AWK file is an experiment issue; check the filename and working directory. For example, `exp10.tcl` references `analysis_bw.awk`, which was absent from this folder during setup.
- This is a legacy Ubuntu environment for local coursework. The configuration exposes only the browser desktop port on `127.0.0.1`.

Build configuration lives in `compose.yaml` and `docker-lab/`. A future first build on another computer needs access to Docker Hub and the Ubuntu package repositories.

## NAM compatibility fix

Ubuntu Xenial's packaged NAM 1.15-3 crashes during Tcl/Tk initialization (Debian bug #820101). This image uses `/usr/local/bin/nam`, rebuilt from Ubuntu's source package with the premature `Tcl_InitStubs` and `Tk_InitStubs` calls removed. The compiled Intel Linux executable is included in `docker-lab/bin/nam`; the original packaged executable remains at `/usr/bin/nam` and should not be used directly.

To regenerate the repaired executable from source, from this folder:

```sh
docker build --platform linux/amd64 -f docker-lab/Dockerfile.nam --output type=local,dest=docker-lab/bin docker-lab
./lab start
```

The rebuild recipe fetches source from Ubuntu's repositories and applies `docker-lab/build-nam.sh`.
