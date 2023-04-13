Delphi Docker File
For using Ubuntu 22.04 LTS (jammy) with PAServer and Indy http(s) components for Delphi 11.3 Alexandria.

Build Dockerfile (watch the dot at the end !) where "delphidev" can be your own name:

sudo docker build --no-cache -t "delphidev:Dockerfile" .

Run (debug mode): 
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it -e PA_SERVER_PASSWORD=<password> -p 64211:64211 -p 8082:8082 delphidev:Dockerfile

Run (no debug mode): 
docker run -it -e PA_SERVER_PASSWORD=<password> -p 64211:64211 -p 8082:8082 delphidev:Dockerfile

ld-linux.exe: error: cannot find -lgcc_s

The problem is that the VM shares the host's Documents folder (like on the h: drive), which is something like " h: \ Home \ Documents \ ...".
This is the case when on a network environment you have your own user drive like on h:\ and Delphi installed the linux SDK on this network drive.
The solution is to copy the Linux SDK to a folder inside the VM or c:\ drive, for example, inside the folder 
"C: \ Users \ Public \ Documents \ Embarcadero \ Studio \ xx.x \ PlatformSDKs" (which is the default local folder).
Then, change/overwrite the BDSPLATFORMSDKSDIR environment variable in Delphi "Options | IDE | Environment variables" to 
this local folder where you copied the Linux SDK. Finally, go to (Options | Deployment | SDK Manager), select the Linux SDK and 
press the "Update local file cache" button. Done. Recompile your project and it will work.
