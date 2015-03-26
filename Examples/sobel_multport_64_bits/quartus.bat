for %%* in (.) do set DIR=%%~n*
cd VHDL
for /r . %%g in (*.vhd) do set BENCH=%%g 
quartus_map %DIR% --source=* --family="Cyclone IV GX"
cd ..
