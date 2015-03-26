for %%* in (.) do set DIR=%%~n*
cd VHDL
for /r . %%g in (*.vhd) do set BENCH=%%g 
quartus_map %DIR% --source=* --family="Cyclone IV GX"
quartus_fit %DIR% --part=EP4CGX150DF31C7
quartus_asm %DIR%
quartus_sta %DIR%
cd ..
cd LALP
for /r . %%g in (*.vhd) do set BENCH=%%g 
quartus_map %DIR% --source=%BENCH% --family="Cyclone IV GX"
quartus_fit %DIR% --part=EP4CGX150DF31C7
quartus_asm %DIR%
quartus_sta %DIR%
cd ..
cd LegUp
for /r . %%g in (*.v) do set BENCH=%%g 
quartus_map top --source=%BENCH% --family="Cyclone IV GX"
quartus_fit top --part=EP4CGX150DF31C7
quartus_asm top
quartus_sta top
cd ..