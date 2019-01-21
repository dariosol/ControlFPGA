name="$1"
extenctionA=".cpp"
extenctionB=".exe"
g++ -g -pthread -m64 -I/opt/root/v5-34-11/include $1$extenctionA  -L/opt/root/v5-34-11/lib -lCore -lCint -lRIO -lNet -lHist -lGraf -lGraf3d -lGpad -lTree -lRint -lPostscript -lMatrix -lPhysics -lMathCore -lThread -lpthread -Wl,-rpath,/opt/root/v5-34-11/lib -lm -ldl -lMinuit  -o $1$extenctionB
